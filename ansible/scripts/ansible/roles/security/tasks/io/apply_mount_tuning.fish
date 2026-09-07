#!/usr/bin/env fish
awk '
BEGIN { OFS="\t" }
/^[^#]/ {
    if ($2 != "/" && $2 != "/boot" && $2 != "/boot/efi" && $3 ~ /^(ext4|xfs|btrfs|f2fs)$/) {
        if ($4 !~ /noatime/) { $4 = $4 ",noatime" }
        if ($4 !~ /nodiratime/) { $4 = $4 ",nodiratime" }
    }
    print $0
}
/^#/ || /^$/ { print $0 }
' /etc/fstab > /tmp/fstab.atomik && mv /tmp/fstab.atomik /etc/fstab
