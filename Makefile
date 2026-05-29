.PHONY: init init-jira-account test-jira-account set-jira-env show-jira-env list-jira-envs require-active-jira-env

JIRA_ENV_DIR := .envs/jira
JIRA_ACTIVE_FILE := .jira-env
ACTIVE_JIRA_ENV := $(strip $(shell test -f $(JIRA_ACTIVE_FILE) && cat $(JIRA_ACTIVE_FILE)))
ACTIVE_JIRA_ENV_FILE := $(if $(ACTIVE_JIRA_ENV),$(JIRA_ENV_DIR)/$(ACTIVE_JIRA_ENV).env,)

ifneq (,$(ACTIVE_JIRA_ENV_FILE))
ifneq (,$(wildcard $(ACTIVE_JIRA_ENV_FILE)))
include $(ACTIVE_JIRA_ENV_FILE)
export
endif
endif

init:
	@echo "Next: run make init-jira-account"

list-jira-envs:
	@set -e; \
	found=0; \
	for file in "$(JIRA_ENV_DIR)"/*.env; do \
		if [ ! -e "$$file" ]; then \
			continue; \
		fi; \
		found=1; \
		name="$${file##*/}"; \
		name="$${name%.env}"; \
		if [ "$$name" = "example" ]; then \
			echo "$$name (example)"; \
		else \
			echo "$$name"; \
		fi; \
	done; \
	if [ "$$found" -eq 0 ]; then \
		echo "No Jira env files found in $(JIRA_ENV_DIR)."; \
	fi

set-jira-env:
	@set -e; \
	if [ -z "$(ENV)" ]; then \
		echo "ENV is required. Usage: make set-jira-env ENV=maklabs" >&2; \
		exit 1; \
	fi; \
	src="$(JIRA_ENV_DIR)/$(ENV).env"; \
	if [ ! -f "$$src" ]; then \
		echo "Jira env file not found: $$src" >&2; \
		exit 1; \
	fi; \
	printf "%s\n" "$(ENV)" > "$(JIRA_ACTIVE_FILE)"; \
	./scripts/jira_env_summary.sh "$$src" "Selected Jira env: $(ENV)" "Active env file: $$src"

show-jira-env:
	@set -e; \
	if [ -z "$(ACTIVE_JIRA_ENV)" ]; then \
		echo "No active Jira env selected. Run make init-jira-account or make set-jira-env ENV=<name>." >&2; \
		exit 1; \
	fi; \
	if [ ! -f "$(ACTIVE_JIRA_ENV_FILE)" ]; then \
		echo "Active Jira env file not found: $(ACTIVE_JIRA_ENV_FILE)" >&2; \
		exit 1; \
	fi; \
	./scripts/jira_env_summary.sh "$(ACTIVE_JIRA_ENV_FILE)" "Active Jira env: $(ACTIVE_JIRA_ENV)"

require-active-jira-env:
	@set -e; \
	if [ -z "$(ACTIVE_JIRA_ENV)" ]; then \
		echo "No active Jira env selected. Run make init-jira-account or make set-jira-env ENV=<name>." >&2; \
		exit 1; \
	fi; \
	if [ ! -f "$(ACTIVE_JIRA_ENV_FILE)" ]; then \
		echo "Active Jira env file not found: $(ACTIVE_JIRA_ENV_FILE)" >&2; \
		exit 1; \
	fi

init-jira-account:
	@./scripts/init_jira_account.sh

test-jira-account: require-active-jira-env
	@ENV_FILE="$(ACTIVE_JIRA_ENV_FILE)" ./scripts/test_jira_account.sh
