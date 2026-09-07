.PHONY: deps run lint test clean help

PROJECT_DIR := $(shell pwd)

help:
	@echo "Usage:"
	@echo "  make deps          Install dependencies (ansible-core, collections)"
	@echo "  make run [CMD=...] Run atomik.fish (default: help)"
	@echo "  make lint          Syntax check all playbooks"
	@echo "  make test          Run e2e tests"
	@echo "  make clean         Remove retry files"
	@echo ""
	@echo "Examples:"
	@echo "  make deps"
	@echo "  make run CMD=core"
	@echo "  make run CMD=cosmic"
	@echo "  make run CMD=security --apply"

deps:
	pkexec rpm-ostree install -y --idempotent --apply-live ansible-core python3-ansible-lint
	pkexec ansible-galaxy collection install ansible.posix community.general

run:
	fish $(PROJECT_DIR)/atomik.fish $(CMD)

lint:
	cd ansible && ansible-playbook --syntax-check site.yml
	cd ansible && ansible-playbook --syntax-check ../tests/e2e.yml
	cd ansible && ansible-playbook --syntax-check ../extra/vscode/site.yml
	cd ansible && ansible-playbook --syntax-check ../extra/gaming/site.yml
	cd ansible && ansible-playbook --syntax-check ../extra/business/site.yml
	cd ansible && ansible-playbook --syntax-check ../extra/devtools/site.yml
	cd ansible && ansible-playbook --syntax-check ../extra/flatpak/site.yml

test:
	cd ansible && ansible-playbook ../tests/e2e.yml -i inventories/localhost/hosts.yml -c local

clean:
	rm -f ansible/*.retry tests/*.retry
