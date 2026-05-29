#!/usr/bin/env bash
set -euo pipefail

PROJECT="${1:-}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"

if [ -z "$PROJECT" ]; then
  echo "PROJECT is required." >&2
  exit 2
fi

env_file="$repo_root/projects/$PROJECT/.env"
bruno_env="$repo_root/projects/$PROJECT/requests/jira/environments/$PROJECT.bru"

if [ ! -f "$env_file" ]; then
  echo "Project env file does not exist: projects/$PROJECT/.env" >&2
  exit 1
fi

mkdir -p "$(dirname "$bruno_env")"

get_env_value() {
  local key="$1"

  awk -v key="$key" '
    $0 ~ "^[[:space:]]*" key "=" {
      sub("^[[:space:]]*" key "=", "")
      print
    }
  ' "$env_file" | tail -n 1
}

write_value() {
  local key="$1"
  local value="$2"

  printf "  %s: %s\n" "$key" "$value"
}

tmp_file="$(mktemp)"

{
  printf "vars {\n"
  write_value "JIRA_PROJECT_URL" "$(get_env_value "JIRA_PROJECT_URL")"
  write_value "JIRA_SITE_URL" "$(get_env_value "JIRA_SITE_URL")"
  write_value "JIRA_PROJECT_KEY" "$(get_env_value "JIRA_PROJECT_KEY")"
  write_value "JIRA_EMAIL" "$(get_env_value "JIRA_EMAIL")"
  write_value "JIRA_API_TOKEN" "$(get_env_value "JIRA_API_TOKEN")"
  write_value "JIRA_CLOUD_ID" "$(get_env_value "JIRA_CLOUD_ID")"
  write_value "GRAPHQL_URL" "https://api.atlassian.com/graphql"
  write_value "ISSUE_KEY" "$(get_env_value "JIRA_PROJECT_KEY")-1"
  write_value "EPIC_KEY" "$(get_env_value "JIRA_PROJECT_KEY")-1"
  write_value "ISSUE_TYPE" "Task"
  write_value "JQL" "project = $(get_env_value "JIRA_PROJECT_KEY") ORDER BY updated DESC"
  printf "}\n"
} > "$tmp_file"

mv "$tmp_file" "$bruno_env"
