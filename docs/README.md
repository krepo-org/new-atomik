# Atomik

Atomik is an Ansible-based declarative configuration for Fedora Atomic desktops (Silverblue, Kinoite, Cosmic Atomic). It adapts to the detected desktop environment at runtime.

## Requirements

4 GB RAM minimum. The system must already be running Fedora Silverblue, Kinoite, or Cosmic Atomic.

## Usage

```bash
make apply         # Apply full configuration
make apply-repos   # Configure repositories
make apply-packages  # Install/remove packages
make apply-security  # Apply security hardening
make apply-desktop   # Configure desktop settings
make apply-devtools  # Set up development tools
make apply-extra-codium  # Install debloated VSCodium
```

## Security

Firewalld, audit rules, hardened kernel parameters, SSH key-only auth, resource limits.

## Memory Management

ZRAM compressed swap, systemd-oomd with desktop-tuned thresholds, no earlyoom.

## Directory Layout

```
ansible/          # Ansible playbooks + roles
extra/            # Optional setup scripts (gnome, nix, codium, devtools)
extra/codium/apply_codium.py     # Install and configure VSCodium
```

## Reset

Revert the system to baseline: uninstall custom packages, remove repositories, delete wallpapers, reset desktop settings.
