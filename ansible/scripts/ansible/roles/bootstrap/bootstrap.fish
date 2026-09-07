#!/usr/bin/env fish

rpm-ostree install -y --idempotent --apply-live ansible-core python3-ansible-lint
ansible-galaxy collection install ansible.posix community.general
