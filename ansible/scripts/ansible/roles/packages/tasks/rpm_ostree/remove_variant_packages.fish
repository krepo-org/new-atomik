#!/usr/bin/env fish
if test -z "$ATOMIK_VARIANT_REMOVE"
  echo "none_to_remove"
  exit 0
end
set TARGET (string split ' ' -- $ATOMIK_VARIANT_REMOVE)
set TO_REMOVE
for p in $TARGET
  if rpm -q --root / $p >/dev/null 2>&1
    set TO_REMOVE $TO_REMOVE $p
  end
end
if test (count $TO_REMOVE) -eq 0
  echo "none_to_remove"
  exit 0
end
if rpm-ostree override remove $TO_REMOVE
  echo "removed: $TO_REMOVE"
else
  for p in $TO_REMOVE
    if rpm-ostree override remove $p 2>/dev/null
      echo "removed: $p"
    else
      echo "skipped: $p"
    end
  end
end
