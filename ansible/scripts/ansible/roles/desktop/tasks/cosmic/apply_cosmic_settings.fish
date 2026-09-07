#!/usr/bin/env fish

set -l target_user $argv[1]
if test -z "$target_user"
    set target_user $USER
end
set -l target_home (getent passwd "$target_user" | cut -d: -f6)
if test -z "$target_home"
    set target_home $HOME
end

# Dynamically find all CosmicIdle versions or default to v1
set -l idle_versions v1
for d in /usr/share/cosmic/com.system76.CosmicIdle/v*
    if test -d "$d"
        set -a idle_versions (basename "$d")
    end
end

for v in (string match -r 'v[0-9]+' $idle_versions | sort -u)
    mkdir -p $target_home/.config/cosmic/com.system76.CosmicIdle/$v
    echo "None" > $target_home/.config/cosmic/com.system76.CosmicIdle/$v/screen_off_time
    echo "None" > $target_home/.config/cosmic/com.system76.CosmicIdle/$v/suspend_on_ac_time
    echo "None" > $target_home/.config/cosmic/com.system76.CosmicIdle/$v/suspend_on_battery_time
end

# Dynamically discover all CosmicSettings.Shortcuts versions and ensure custom shortcuts exist
set -l shortcut_versions v1
for d in /usr/share/cosmic/com.system76.CosmicSettings.Shortcuts/v*
    if test -d "$d"
        set -a shortcut_versions (basename "$d")
    end
end

for v in (string match -r 'v[0-9]+' $shortcut_versions | sort -u)
    mkdir -p $target_home/.config/cosmic/com.system76.CosmicSettings.Shortcuts/$v
    if not test -f $target_home/.config/cosmic/com.system76.CosmicSettings.Shortcuts/$v/custom
        echo "{}" > $target_home/.config/cosmic/com.system76.CosmicSettings.Shortcuts/$v/custom
    end
end

# Dynamically discover all system themes and versions, replicating missing fallback keys
for themedir in /usr/share/cosmic/com.system76.CosmicTheme.*
    test -d "$themedir"; or continue
    set -l tname (basename "$themedir")
    for verdir in "$themedir"/v*
        test -d "$verdir"; or continue
        set -l ver (basename "$verdir")
        mkdir -p $target_home/.config/cosmic/$tname/$ver
        for file in "$verdir"/*
            test -f "$file"; or continue
            set -l fname (basename "$file")
            if not test -e $target_home/.config/cosmic/$tname/$ver/"$fname"
                cp -a "$file" $target_home/.config/cosmic/$tname/$ver/"$fname"
            end
        end
    end
end

# Ensure modern theme compatibility flags
for vdir in $target_home/.config/cosmic/com.system76.CosmicTheme.*/v*
    if test -d "$vdir" -a ! -e "$vdir/frosted_maximized_apps"
        echo "false" > "$vdir/frosted_maximized_apps"
    end
end

# Fix ownership if running as root
if test (id -u) -eq 0 -a "$target_user" != "root"
    chown -R "$target_user:$target_user" "$target_home/.config/cosmic" 2>/dev/null
end

killall -u "$target_user" cosmic-idle 2>/dev/null
