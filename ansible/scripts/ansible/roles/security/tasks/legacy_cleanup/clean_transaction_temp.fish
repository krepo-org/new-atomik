#!/usr/bin/env fish
set -l targets /var/home/$ATOMIK_USER/.tmp/bora-transaction-*
if test (count $targets) -gt 0 -a -e $targets[1]
    rm -rf $targets
end
