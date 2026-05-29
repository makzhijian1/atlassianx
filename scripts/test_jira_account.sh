#!/usr/bin/env bash
set -euo pipefail

JIRA_ENV_DIR=".envs/jira"
JIRA_ACTIVE_FILE=".jira-env"
ENV_FILE="${ENV_FILE:-}"

if [ -z "$ENV_FILE" ] && [ -f "$JIRA_ACTIVE_FILE" ]; then
  active_env="$(cat "$JIRA_ACTIVE_FILE")"
  ENV_FILE="$JIRA_ENV_DIR/$active_env.env"
fi

if [ -z "$ENV_FILE" ]; then
  ENV_FILE=".env"
fi

get_env_value() {
  local key="$1"

  if [ ! -f "$ENV_FILE" ]; then
    return 0
  fi

  grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d= -f2-
}

require_value() {
  local key="$1"
  local value="$2"

  if [ -z "$value" ]; then
    echo "Missing $key in $ENV_FILE." >&2
    return 1
  fi
}

redact_token_checks() {
  local value="$1"
  local first=""
  local last=""
  local quoted="no"

  if [ -n "$value" ]; then
    first="${value:0:1}"
    last="${value: -1}"

    if { [ "$first" = '"' ] && [ "$last" = '"' ]; } || { [ "$first" = "'" ] && [ "$last" = "'" ]; }; then
      quoted="yes"
    fi
  fi

  printf "token_length=%d leading_space=%s trailing_space=%s has_cr=%s quoted=%s" \
    "${#value}" \
    "$([ "${value# }" != "$value" ] && printf yes || printf no)" \
    "$([ "${value% }" != "$value" ] && printf yes || printf no)" \
    "$(printf "%s" "$value" | grep -q "$(printf '\r')" && printf yes || printf no)" \
    "$quoted"
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

print_selected_headers() {
  local headers_file="$1"

  awk 'BEGIN { IGNORECASE = 1 }
    /^www-authenticate:|^x-seraph-loginreason:|^x-ausername:|^content-type:/ {
      gsub(/\r$/, "")
      print "  " $0
    }' "$headers_file"
}

print_body_preview() {
  local body_file="$1"

  if [ -s "$body_file" ]; then
    printf "  "
    head -c 500 "$body_file" | sed "s/[[:cntrl:]]/ /g"
    printf "\n"
  fi
}

fail_auth() {
  local status="$1"
  local headers_file="$2"
  local body_file="$3"

  echo "Jira account authentication failed with HTTP $status." >&2
  echo "This failed before checking project access." >&2
  echo "Auth details used: email=${JIRA_EMAIL}, $(redact_token_checks "$JIRA_API_TOKEN")" >&2
  echo "Selected response headers:" >&2
  print_selected_headers "$headers_file" >&2
  echo "Response body preview:" >&2
  print_body_preview "$body_file" >&2
  echo >&2
  echo "Likely fixes:" >&2
  echo "- Confirm the token was created under the same Atlassian account email saved in JIRA_EMAIL." >&2
  echo "- If you have multiple Atlassian accounts in the browser, switch to the account that owns this Jira project before creating the token." >&2
  echo "- Use an Atlassian account API token for Jira Cloud, not a token name, token ID, org admin API key, OAuth client secret, or app password." >&2
  echo "- Re-run make init-jira-account to replace the saved Jira env profile." >&2
  exit 1
}

fail_project() {
  local status="$1"
  local headers_file="$2"
  local body_file="$3"

  echo "Jira authentication succeeded, but project access failed with HTTP $status for ${JIRA_PROJECT_KEY}." >&2
  echo "Selected response headers:" >&2
  print_selected_headers "$headers_file" >&2
  echo "Response body preview:" >&2
  print_body_preview "$body_file" >&2
  echo >&2
  echo "Likely fixes:" >&2
  echo "- Confirm ${JIRA_PROJECT_KEY} is the project key from the Jira URL." >&2
  echo "- Confirm ${JIRA_EMAIL} can view that project in the Jira web UI." >&2
  echo "- Re-run make init-jira-account if this checkout should target a different project." >&2
  exit 1
}

JIRA_SITE_URL="$(get_env_value "JIRA_SITE_URL")"
JIRA_PROJECT_KEY="$(get_env_value "JIRA_PROJECT_KEY")"
JIRA_EMAIL="$(get_env_value "JIRA_EMAIL")"
JIRA_API_TOKEN="$(get_env_value "JIRA_API_TOKEN")"

require_value "JIRA_SITE_URL" "$JIRA_SITE_URL"
require_value "JIRA_PROJECT_KEY" "$JIRA_PROJECT_KEY"
require_value "JIRA_EMAIL" "$JIRA_EMAIL"
require_value "JIRA_API_TOKEN" "$JIRA_API_TOKEN"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required to test Jira connectivity." >&2
  exit 1
fi

auth_header="$(basic_auth_header "$JIRA_EMAIL" "$JIRA_API_TOKEN")"

echo "Checking Jira account authentication..."
headers_file="$(mktemp)"
body_file="$(mktemp)"
status="$(request_json "${JIRA_SITE_URL}/rest/api/3/myself" "$headers_file" "$body_file" "$auth_header")"

if [ "$status" != "200" ]; then
  fail_auth "$status" "$headers_file" "$body_file"
fi

echo "Checking Jira project access for ${JIRA_PROJECT_KEY}..."
headers_file="$(mktemp)"
body_file="$(mktemp)"
status="$(request_json "${JIRA_SITE_URL}/rest/api/3/project/${JIRA_PROJECT_KEY}" "$headers_file" "$body_file" "$auth_header")"

if [ "$status" != "200" ]; then
  fail_project "$status" "$headers_file" "$body_file"
fi

echo "Jira account verified for ${JIRA_EMAIL} on ${JIRA_SITE_URL}, project ${JIRA_PROJECT_KEY}."
