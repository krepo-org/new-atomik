#!/usr/bin/env fish

set -l script_dir (cd (dirname (status filename)); and pwd)
set -gx ANSIBLE_CONFIG "$script_dir/ansible/ansible.cfg"
set -l inventory "$script_dir/ansible/inventories/localhost/hosts.yml"

set -l ansible_bin (command -v ansible-playbook; or echo "$HOME/.local/bin/ansible-playbook")
if not test -x "$ansible_bin"
    echo (set_color red)"Error: ansible-playbook not found in PATH or ~/.local/bin."(set_color normal) >&2
    exit 1
end

set -l dry_run true
for arg in $argv
    if test "$arg" = "--apply"
        set dry_run false
        break
    end
end

function in_flatpak
    test -f /.flatpak-info; or test -n "$FLATPAK_ID"; or test -f /run/.toolboxenv
end

function host_cmd
    if in_flatpak
        flatpak-spawn --host $argv
    else
        $argv
    end
end

function run_root -V script_dir -V ANSIBLE_CONFIG -V dry_run
    set -l cmd $argv
    if test "$dry_run" = true
        set cmd $cmd --check --diff
    end
    if test (id -u) -eq 0
        $cmd
    else if in_flatpak
        flatpak-spawn --host pkexec env ANSIBLE_CONFIG="$ANSIBLE_CONFIG" $cmd
    else if command -v pkexec >/dev/null 2>&1; and test -n "$DISPLAY" -o -n "$WAYLAND_DISPLAY"
        pkexec env ANSIBLE_CONFIG="$ANSIBLE_CONFIG" $cmd
    else
        sudo env ANSIBLE_CONFIG="$ANSIBLE_CONFIG" $cmd
    end
end

function run_user -V script_dir -V dry_run
    set -l cmd $argv
    if test "$dry_run" = true
        set cmd $cmd --check --diff
    end
    if in_flatpak
        flatpak-spawn --host $cmd
    else
        $cmd
    end
end

function show_usage
    echo (set_color blue)"Atomik Management CLI (Fish)"(set_color normal)
    echo "Usage: ./atomik.fish <command> [--apply] [ansible-playbook options...]"
    echo ""
    echo (set_color yellow)"Default: dry-run (--check --diff). Use --apply to execute."(set_color normal)
    echo ""
    echo (set_color green)"Core & System:"(set_color normal)
    echo "  core             Configure system (ansible/site.yml)"
    echo "  all              Apply core + all extra modules"
    echo "  security         Apply security, GPU tuning, thermald, udev, kernel"
    echo "  repos            Configure system repositories"
    echo "  packages         Apply rpm-ostree packages"
    echo "  install-deps     Install ansible-core and collections via rpm-ostree"
    echo ""
    echo (set_color green)"Desktop & User:"(set_color normal)
    echo "  desktop          Configure desktop environment (COSMIC)"
    echo "  cosmic           Configure COSMIC desktop, idle, themes"
    echo "  extra            Apply all extra modules (flatpak, gaming, devtools, etc.)"
    echo "  flatpak          Install and configure base Flatpaks"
    echo "  gaming           Install gaming Flatpaks (Discord, Heroic) with Wayland"
    echo "  business         Install business Flatpaks (Slack) with Wayland"
    echo "  devtools         Install dev tools (rustup, pnpm)"
    echo "  vscode           Install and configure VS Code"
    echo ""
    echo (set_color green)"Verification & Quality:"(set_color normal)
    echo "  lint             Syntax check all playbooks"
    echo "  test             Run end-to-end test suite"
    echo "  clean            Remove temporary files and .retry files"
    echo ""
    echo (set_color yellow)"Examples:"(set_color normal)
    echo "  ./atomik.fish cosmic              # dry-run COSMIC config"
    echo "  ./atomik.fish cosmic --apply      # actually apply COSMIC config"
    echo "  ./atomik.fish security --apply    # apply security hardening"
end

set -l cmd $argv[1]
set -l extra_args $argv[2..-1]

switch "$cmd"
    case core
        echo (set_color blue)"==>"(set_color normal) "Core system configuration..."
        run_root $ansible_bin $script_dir/ansible/site.yml -i $inventory $extra_args

    case all
        echo (set_color blue)"==>"(set_color normal) "Core configuration..."
        run_root $ansible_bin $script_dir/ansible/site.yml -i $inventory $extra_args
        for extra in flatpak gaming business devtools vscode
            if test -f "$script_dir/extra/$extra/site.yml"
                echo (set_color blue)"==>"(set_color normal) "extra/$extra..."
                run_user $ansible_bin $script_dir/extra/$extra/site.yml -i $inventory $extra_args
            end
        end

    case security
        echo (set_color blue)"==>"(set_color normal) "Security and hardware tuning..."
        run_root $ansible_bin $script_dir/ansible/site.yml -i $inventory --tags security $extra_args

    case repos
        echo (set_color blue)"==>"(set_color normal) "Repository configuration..."
        run_root $ansible_bin $script_dir/ansible/site.yml -i $inventory --tags repos $extra_args

    case packages
        echo (set_color blue)"==>"(set_color normal) "rpm-ostree packages..."
        run_root $ansible_bin $script_dir/ansible/site.yml -i $inventory --tags packages $extra_args

    case desktop
        echo (set_color blue)"==>"(set_color normal) "Desktop configuration..."
        run_user $ansible_bin $script_dir/ansible/site.yml -i $inventory --tags desktop $extra_args

    case cosmic
        echo (set_color blue)"==>"(set_color normal) "COSMIC desktop configuration..."
        run_user $ansible_bin $script_dir/ansible/site.yml -i $inventory --tags cosmic $extra_args

    case extra
        echo (set_color blue)"==>"(set_color normal) "All extra modules..."
        for extra in flatpak gaming business devtools vscode
            if test -f "$script_dir/extra/$extra/site.yml"
                echo (set_color blue)"==>"(set_color normal) "extra/$extra..."
                run_user $ansible_bin $script_dir/extra/$extra/site.yml -i $inventory $extra_args
            end
        end

    case flatpak
        echo (set_color blue)"==>"(set_color normal) "Base Flatpak setup..."
        run_user $ansible_bin $script_dir/extra/flatpak/site.yml -i $inventory $extra_args

    case gaming
        echo (set_color blue)"==>"(set_color normal) "Gaming Flatpaks..."
        run_user $ansible_bin $script_dir/extra/gaming/site.yml -i $inventory $extra_args

    case business
        echo (set_color blue)"==>"(set_color normal) "Business Flatpaks..."
        run_user $ansible_bin $script_dir/extra/business/site.yml -i $inventory $extra_args

    case devtools
        echo (set_color blue)"==>"(set_color normal) "Dev tools..."
        run_user $ansible_bin $script_dir/extra/devtools/site.yml -i $inventory $extra_args

    case vscode
        echo (set_color blue)"==>"(set_color normal) "VS Code..."
        run_user $ansible_bin $script_dir/extra/vscode/site.yml -i $inventory $extra_args

    case lint
        echo (set_color blue)"==>"(set_color normal) "Syntax check all playbooks..."
        for pb in $script_dir/ansible/site.yml $script_dir/tests/e2e.yml $script_dir/extra/*/site.yml
            if test -f "$pb"
                $ansible_bin --syntax-check "$pb" -i $inventory
            end
        end

    case test
        echo (set_color blue)"==>"(set_color normal) "Running e2e test suite..."
        run_user $ansible_bin $script_dir/tests/e2e.yml -i $inventory -c local $extra_args

    case install-deps
        echo (set_color blue)"==>"(set_color normal) "Installing ansible-core and collections..."
        run_root rpm-ostree install -y --idempotent --apply-live ansible-core python3-ansible-lint
        run_user ansible-galaxy collection install ansible.posix community.general

    case clean
        echo (set_color blue)"==>"(set_color normal) "Cleaning temporary files..."
        rm -f $script_dir/ansible/*.retry $script_dir/tests/*.retry
        echo "Cleanup complete."

    case help --help -h ""
        show_usage

    case '*'
        echo (set_color red)"Error: Unknown command '$cmd'"(set_color normal) >&2
        echo ""
        show_usage
        exit 1
end
