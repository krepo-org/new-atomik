.PHONY: all lint check test install-deps apply-core apply-all clean help
.PHONY: apply-only-repos apply-only-packages apply-only-security apply-only-desktop
.PHONY: apply-extra apply-extra-gnome apply-extra-codium apply-extra-devtools apply-extra-flatpak apply-extra-gaming apply-extra-business

PROJECT_DIR := $(shell pwd)
ANSIBLE_CONFIG = $(PROJECT_DIR)/ansible/ansible.cfg
ANSIBLE_PLAYBOOK = env ANSIBLE_CONFIG=$(ANSIBLE_CONFIG) ansible-playbook $(PROJECT_DIR)/ansible/site.yml -i $(PROJECT_DIR)/ansible/inventories/localhost/hosts.yml
E2E_PLAYBOOK = env ANSIBLE_CONFIG=$(ANSIBLE_CONFIG) ansible-playbook $(PROJECT_DIR)/tests/e2e.yml -i $(PROJECT_DIR)/ansible/inventories/localhost/hosts.yml -c local
EXTRA_PLAYBOOK = env ANSIBLE_CONFIG=$(ANSIBLE_CONFIG) ansible-playbook
all: lint test

help:
	@echo "Usage:"
	@echo "  make all                  Run lint + test"
	@echo "  make lint                 Syntax check all playbooks"
	@echo "  make test                 Run e2e tests"
	@echo "  make apply-core           Apply core configuration (ansible)"
	@echo "  make apply-extra          Apply all extra configs"
	@echo "  make apply-all            Apply core + all extras"
	@echo "  make apply-only-repos     Apply repos only"
	@echo "  make apply-only-packages  Apply packages only"
	@echo "  make apply-only-security  Apply security only"
	@echo "  make apply-only-desktop   Apply desktop only"
	@echo "  make apply-extra-gnome    Apply GNOME theme/settings"
	@echo "  make apply-extra-codium   Install and configure debloated VSCodium"
	@echo "  make apply-extra-devtools Install dev tools (nvm, pnpm, rustup, sdkman, opencode)"
	@echo "  make apply-extra-flatpak  Install Flatpak runtime and remotes"
	@echo "  make apply-extra-gaming   Install gaming Flatpaks (Discord, Heroic)"
	@echo "  make apply-extra-business Install business Flatpaks (Slack)"
	@echo "  make install-deps         Install ansible-core + collections"
	@echo "  make clean                Remove ansible retry files"

apply-all: apply-core apply-extra

apply-extra: apply-extra-gnome apply-extra-codium apply-extra-devtools apply-extra-flatpak apply-extra-gaming apply-extra-business

apply-extra-gnome:
	$(EXTRA_PLAYBOOK) $(PROJECT_DIR)/extra/gnome/site.yml -i $(PROJECT_DIR)/ansible/inventories/localhost/hosts.yml

apply-extra-codium:
	$(EXTRA_PLAYBOOK) $(PROJECT_DIR)/extra/codium/site.yml -i $(PROJECT_DIR)/ansible/inventories/localhost/hosts.yml

apply-extra-devtools:
	$(EXTRA_PLAYBOOK) $(PROJECT_DIR)/extra/devtools/site.yml -i $(PROJECT_DIR)/ansible/inventories/localhost/hosts.yml

apply-extra-flatpak:
	$(EXTRA_PLAYBOOK) $(PROJECT_DIR)/extra/flatpak/site.yml -i $(PROJECT_DIR)/ansible/inventories/localhost/hosts.yml

apply-extra-gaming:
	$(EXTRA_PLAYBOOK) $(PROJECT_DIR)/extra/gaming/site.yml -i $(PROJECT_DIR)/ansible/inventories/localhost/hosts.yml

apply-extra-business:
	$(EXTRA_PLAYBOOK) $(PROJECT_DIR)/extra/business/site.yml -i $(PROJECT_DIR)/ansible/inventories/localhost/hosts.yml

lint:
	cd ansible && ansible-playbook --syntax-check site.yml
	cd ansible && ansible-playbook --syntax-check ../tests/e2e.yml
	cd ansible && ansible-playbook --syntax-check ../extra/codium/site.yml
	cd ansible && ansible-playbook --syntax-check ../extra/gaming/site.yml
	cd ansible && ansible-playbook --syntax-check ../extra/business/site.yml
	cd ansible && ansible-playbook --syntax-check ../extra/gnome/site.yml
	cd ansible && ansible-playbook --syntax-check ../extra/devtools/site.yml
	cd ansible && ansible-playbook --syntax-check ../extra/flatpak/site.yml

test:
	$(E2E_PLAYBOOK)

install-deps:
	pkexec rpm-ostree install -y --idempotent --apply-live ansible-core python3-ansible-lint
	pkexec ansible-galaxy collection install ansible.posix community.general

apply-only-repos:
	pkexec $(ANSIBLE_PLAYBOOK) --tags repos

apply-only-packages:
	pkexec $(ANSIBLE_PLAYBOOK) --tags packages

apply-only-security:
	pkexec $(ANSIBLE_PLAYBOOK) --tags security

apply-only-desktop:
	pkexec $(ANSIBLE_PLAYBOOK) --tags desktop

apply-core:
	pkexec $(ANSIBLE_PLAYBOOK)

clean:
	rm -f ansible/*.retry tests/*.retry
