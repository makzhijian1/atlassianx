#!/usr/bin/env bash
set -euo pipefail

JIRA_ENV_DIR=".envs/jira"
JIRA_ACTIVE_FILE=".jira-env"
TOKEN_PAGE="https://id.atlassian.com/manage-profile/security/api-tokens"

prompt_required() {
  local label="$1"
  local value=""

  while [ -z "$value" ]; do
    printf "%s: " "$label" >&2
    IFS= read -r value
  done

  printf "%s" "$value"
}

validate_env_name() {
  local name="$1"

  case "$name" in
    ""|*".."*|*/*|*\\*)
      return 1
      ;;
  esac

  case "$name" in
    *[!A-Za-z0-9._-]*)
      return 1
      ;;
  esac
}

set_env_value() {
  local key="$1"
  local value="$2"
  local tmp_file

  tmp_file="$(mktemp)"

  if grep -q "^${key}=" "$ENV_FILE"; then
    awk -v key="$key" -v value="$value" 'BEGIN { replacement = key "=" value } $0 ~ "^" key "=" { print replacement; next } { print }' "$ENV_FILE" > "$tmp_file"
  else
    cp "$ENV_FILE" "$tmp_file"
    printf "%s=%s\n" "$key" "$value" >> "$tmp_file"
  fi

  mv "$tmp_file" "$ENV_FILE"
}

derive_site_url() {
  local project_url="$1"
  printf "%s" "$project_url" | sed -E 's#^(https?://[^/]+).*#\1#'
}

derive_project_key() {
  local project_url="$1"
  printf "%s" "$project_url" | sed -nE 's#.*[/?&]projects/([^/?#&]+).*#\1#p'
}

open_token_page() {
  if command -v open >/dev/null 2>&1; then
    if ! open "$TOKEN_PAGE" >/dev/null 2>&1; then
      echo "Open this page in your browser: $TOKEN_PAGE"
    fi
  else
    echo "Open this page in your browser: $TOKEN_PAGE"
  fi
}

read_token() {
  local value=""

  if [ -t 0 ]; then
    stty -echo
    IFS= read -r value
    stty echo
    printf "\n" >&2
  else
    IFS= read -r value
  fi

  printf "%s" "$value"
}

basic_auth_header() {
  local email="$1"
  local token="$2"
  local encoded

  encoded="$(printf "%s:%s" "$email" "$token" | base64 | tr -d "\n")"
  printf "Authorization: Basic %s" "$encoded"
}

request_json() {
  local url="$1"
  local headers_file="$2"
  local body_file="$3"
  local auth_header="$4"

  curl -sS \
    -D "$headers_file" \
    -o "$body_file" \
    -w "%{http_code}" \
    -H "$auth_header" \
    -H "Accept: application/json" \
    "$url" || true
}

extract_cloud_id() {
  local body_file="$1"

  sed -nE 's/.*"cloudId"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' "$body_file" | head -n 1
}

fetch_cloud_id() {
  local site_url="$1"
  local email="$2"
  local token="$3"
  local auth_header
  local headers_file
  local body_file
  local status
  local cloud_id

  if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to retrieve Jira Cloud ID." >&2
    exit 1
  fi

  auth_header="$(basic_auth_header "$email" "$token")"
  headers_file="$(mktemp)"
  body_file="$(mktemp)"
  status="$(request_json "${site_url%/}/_edge/tenant_info" "$headers_file" "$body_file" "$auth_header")"

  if [ "$status" != "200" ]; then
    echo "Could not retrieve Jira Cloud ID for $site_url. HTTP $status." >&2
    echo "Response body preview:" >&2
    if [ -s "$body_file" ]; then
      printf "  " >&2
      head -c 500 "$body_file" | sed "s/[[:cntrl:]]/ /g" >&2
      printf "\n" >&2
    fi
    exit 1
  fi

  cloud_id="$(extract_cloud_id "$body_file")"
  if [ -z "$cloud_id" ]; then
    echo "Could not parse Jira Cloud ID from ${site_url%/}/_edge/tenant_info." >&2
    exit 1
  fi

  printf "%s" "$cloud_id"
}

env_name="$(prompt_required "Jira env name, e.g. maklabs")"
if ! validate_env_name "$env_name"; then
  echo "Invalid Jira env name: $env_name" >&2
  echo "Use only letters, numbers, dots, underscores, and hyphens." >&2
  exit 1
fi

mkdir -p "$JIRA_ENV_DIR"
ENV_FILE="$JIRA_ENV_DIR/$env_name.env"

if [ ! -f "$ENV_FILE" ]; then
  : > "$ENV_FILE"
  echo "Created $ENV_FILE."
fi

project_url="$(prompt_required "Jira project URL, e.g. https://maklabs.atlassian.net/jira/software/projects/MZJ2026")"
site_url="$(derive_site_url "$project_url")"
project_key="$(derive_project_key "$project_url")"

if [ "$site_url" = "$project_url" ] || [ -z "$project_key" ]; then
  echo "Could not derive Jira site URL and project key from: $project_url" >&2
  echo "Expected a Jira project URL like https://maklabs.atlassian.net/jira/software/projects/MZJ2026" >&2
  exit 1
fi

email="$(prompt_required "Jira registered email")"

token_exists=""
while true; do
  printf "Do you already have a Jira API token? [Y/N]: "
  IFS= read -r token_exists

  case "$token_exists" in
    [Yy])
      break
      ;;
    [Nn])
      echo
      echo "Opening Atlassian API token management."
      open_token_page
      echo
      echo "Create a Jira API token:"
      echo "1. Sign in with the Jira registered email."
      echo "2. Select Create API token."
      echo "3. Give it a clear label, for example atlassianx-local."
      echo "4. Copy the token before closing the page."
      echo
      break
      ;;
    *)
      echo "Please answer Y or N."
      ;;
  esac
done

token=""
while [ -z "$token" ]; do
  printf "Jira API token: " >&2
  token="$(read_token)"
done

set_env_value "JIRA_PROJECT_URL" "$project_url"
set_env_value "JIRA_SITE_URL" "$site_url"
set_env_value "JIRA_PROJECT_KEY" "$project_key"
set_env_value "JIRA_EMAIL" "$email"
set_env_value "JIRA_API_TOKEN" "$token"

printf "%s\n" "$env_name" > "$JIRA_ACTIVE_FILE"

echo "Saved Jira API access settings to $ENV_FILE."
echo "Selected Jira env: $env_name"
echo "Testing Jira connectivity for $project_key on $site_url..."
REQUIRE_CLOUD_ID=0 ENV_FILE="$ENV_FILE" ./scripts/test_jira_account.sh

echo "Retrieving Jira Cloud ID for $site_url..."
cloud_id="$(fetch_cloud_id "$site_url" "$email" "$token")"
set_env_value "JIRA_CLOUD_ID" "$cloud_id"

echo "Saved Jira Cloud ID to $ENV_FILE."
echo "Verifying refreshed Jira profile..."
ENV_FILE="$ENV_FILE" ./scripts/test_jira_account.sh
./scripts/jira_env_summary.sh "$ENV_FILE" "Selected Jira env: $env_name"
