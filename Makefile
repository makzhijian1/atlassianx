.PHONY: ensure-env init init-jira-account test-jira-account diagnose-jira-account test-jira

ENV_FILE := .env
ENV_EXAMPLE := .env.example

ensure-env:
	@set -e; \
	if [ ! -f "$(ENV_FILE)" ]; then \
		cp "$(ENV_EXAMPLE)" "$(ENV_FILE)"; \
		echo "Created $(ENV_FILE) from $(ENV_EXAMPLE)."; \
	else \
		echo "$(ENV_FILE) already exists."; \
	fi

init: ensure-env
	@echo "Next: run make init-jira-account"

init-jira-account: ensure-env
	@./scripts/init_jira_account.sh

test-jira-account: ensure-env
	@./scripts/test_jira_account.sh

diagnose-jira-account: test-jira-account

test-jira: test-jira-account
