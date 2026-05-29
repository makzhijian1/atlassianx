#!/usr/bin/env bash
set -euo pipefail

PROJECT="${1:-}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"
template_env="$repo_root/setup/templates/project.env.example"
template_collection="$repo_root/setup/requests/bruno-jira-template"

fail_project_required() {
  echo "PROJECT is required." >&2
  echo >&2
  echo "Example:" >&2
  echo "make show-jira-env PROJECT=maklabs" >&2
  exit 1
}

validate_project() {
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

copy_if_missing() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$dest" ]; then
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
  fi
}

copy_collection_file() {
  local rel="$1"
  local dest_rel="$2"

  copy_if_missing "$template_collection/$rel" "$project_dir/requests/jira/$dest_rel"
}

if [ -z "$PROJECT" ]; then
  fail_project_required
fi

if ! validate_project "$PROJECT"; then
  echo "Invalid PROJECT: $PROJECT" >&2
  echo "Use only letters, numbers, dots, underscores, and hyphens." >&2
  exit 1
fi

project_dir="$repo_root/projects/$PROJECT"
project_bruno_env="$project_dir/requests/jira/environments/$PROJECT.bru"

if [ -e "$project_dir" ] && [ ! -d "$project_dir" ]; then
  echo "Project path exists but is not a directory: projects/$PROJECT" >&2
  exit 1
fi

if [ ! -f "$template_env" ]; then
  echo "Project env template not found: setup/templates/project.env.example" >&2
  exit 1
fi

if [ ! -d "$template_collection" ]; then
  echo "Bruno template collection not found: setup/requests/bruno-jira-template" >&2
  exit 1
fi

mkdir -p \
  "$project_dir/issues/local" \
  "$project_dir/issues/remote" \
  "$project_dir/requests/jira/environments" \
  "$project_dir/requests/jira/rest" \
  "$project_dir/requests/jira/graphql"

copy_if_missing "$template_env" "$project_dir/.env"

bruno_env_already_existed=0
if [ -e "$project_bruno_env" ]; then
  bruno_env_already_existed=1
fi

copy_collection_file "bruno.json" "bruno.json"
copy_collection_file "collection.bru" "collection.bru"
copy_collection_file "environments/project.bru" "environments/$PROJECT.bru"
copy_collection_file "rest/folder.bru" "rest/folder.bru"
copy_collection_file "rest/get-issue.bru" "rest/get-issue.bru"
copy_collection_file "rest/get-epic-issues.bru" "rest/get-epic-issues.bru"
copy_collection_file "rest/search-jql.bru" "rest/search-jql.bru"
copy_collection_file "rest/create-issue.bru" "rest/create-issue.bru"
copy_collection_file "rest/update-issue.bru" "rest/update-issue.bru"
copy_collection_file "graphql/folder.bru" "graphql/folder.bru"
copy_collection_file "graphql/get-cloud-id.bru" "graphql/get-cloud-id.bru"
copy_collection_file "graphql/get-issue.bru" "graphql/get-issue.bru"
copy_collection_file "graphql/get-epic-issues.bru" "graphql/get-epic-issues.bru"
copy_collection_file "graphql/search-jql.bru" "graphql/search-jql.bru"

if [ "$bruno_env_already_existed" -eq 0 ]; then
  "$script_dir/sync_bruno_env.sh" "$PROJECT"
fi

echo "Initialized project workspace: projects/$PROJECT"
echo
echo "Created or verified:"
echo "- projects/$PROJECT/.env"
echo "- projects/$PROJECT/issues/local/"
echo "- projects/$PROJECT/issues/remote/"
echo "- projects/$PROJECT/requests/jira/"
echo "- projects/$PROJECT/requests/jira/environments/$PROJECT.bru"
echo
echo "Next: run make init-jira-account PROJECT=$PROJECT"
