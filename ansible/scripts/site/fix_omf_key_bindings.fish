#!/usr/bin/env fish

set omf_init ~/.local/share/omf/init.fish
test -f $omf_init; or exit 0
grep -q __original_fish_user_key_bindings $omf_init; or exit 0

sed -i '/__original_fish_user_key_bindings/d' $omf_init
sed -i '/# Backup key bindings/d' $omf_init
sed -i '/# Call original key bindings if existent/d' $omf_init

echo "Fixed OMF init.fish"
