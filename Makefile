.PHONY: init init-project init-jira-account show-jira-env test-jira-account require-project

PROJECT_ENV_FILE = projects/$(PROJECT)/.env

init:
	@echo "Next: run make init-project PROJECT=maklabs"

require-project:
	@set -e; \
	if [ -z "$(PROJECT)" ]; then \
		echo "PROJECT is required." >&2; \
		echo >&2; \
		echo "Example:" >&2; \
		echo "make show-jira-env PROJECT=maklabs" >&2; \
		exit 1; \
	fi; \
	case "$(PROJECT)" in \
		*..*|*/*|*\\*|*[!A-Za-z0-9._-]*) \
			echo "Invalid PROJECT: $(PROJECT)" >&2; \
			echo "Use only letters, numbers, dots, underscores, and hyphens." >&2; \
			exit 1 ;; \
	esac

init-project: require-project
	@setup/scripts/init_project.sh "$(PROJECT)"

init-jira-account: require-project
	@setup/scripts/init_jira_account.sh "$(PROJECT)"

show-jira-env: require-project
	@setup/scripts/jira_env_summary.sh "$(PROJECT_ENV_FILE)" "Jira project env: $(PROJECT)" "Project env file: $(PROJECT_ENV_FILE)"

test-jira-account: require-project
	@ENV_FILE="$(PROJECT_ENV_FILE)" setup/scripts/test_jira_account.sh
