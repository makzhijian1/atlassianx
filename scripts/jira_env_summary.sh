#!/usr/bin/env bash
set -euo pipefail

env_file="${1:-}"
heading="${2:-}"
footer="${3:-}"

if [ -z "$env_file" ]; then
  echo "Usage: scripts/jira_env_summary.sh <env-file> [heading] [footer]" >&2
  exit 2
fi

if [ ! -f "$env_file" ]; then
  echo "Jira env file does not exist: $env_file" >&2
  exit 1
fi

get_env_value() {
  local key="$1"

  awk -v key="$key" '
    $0 ~ "^[[:space:]]*" key "=" {
      sub("^[[:space:]]*" key "=", "")
      print
    }
  ' "$env_file" | tail -n 1
}

require_value() {
  local key="$1"
  local value="$2"

  if [ -z "$value" ]; then
    echo "Missing $key in $env_file." >&2
    exit 1
  fi
}

jira_site_url="$(get_env_value "JIRA_SITE_URL")"
jira_project_key="$(get_env_value "JIRA_PROJECT_KEY")"
jira_email="$(get_env_value "JIRA_EMAIL")"

require_value "JIRA_SITE_URL" "$jira_site_url"
require_value "JIRA_PROJECT_KEY" "$jira_project_key"
require_value "JIRA_EMAIL" "$jira_email"

if [ -n "$heading" ]; then
  echo "$heading"
fi

echo "JIRA_SITE_URL=$jira_site_url"
echo "JIRA_PROJECT_KEY=$jira_project_key"
echo "JIRA_EMAIL=$jira_email"

if [ -n "$footer" ]; then
  echo "$footer"
fi
