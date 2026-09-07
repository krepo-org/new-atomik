#!/usr/bin/env fish
firewall-cmd --permanent --add-service $argv[1]
firewall-cmd --reload
