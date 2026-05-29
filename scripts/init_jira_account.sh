#!/usr/bin/env bash
set -euo pipefail

ENV_FILE=".env"
TOKEN_PAGE="https://id.atlassian.com/manage-profile/security/api-tokens"

if [ ! -f "$ENV_FILE" ]; then
  cp .env.example "$ENV_FILE"
  echo "Created $ENV_FILE from .env.example."
fi

prompt_required() {
  local label="$1"
  local value=""

  while [ -z "$value" ]; do
    printf "%s: " "$label" >&2
    IFS= read -r value
  done

  printf "%s" "$value"
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

echo "Saved Jira API access settings to $ENV_FILE."
echo "Testing Jira connectivity for $project_key on $site_url..."
./scripts/test_jira_account.sh
