#!/usr/bin/env sh


swaynag -t warning -m "Use autotiling or not?" \
  -b "Yes" "pkill autotiling; autotiling -l 2; exit" \
  -b "No" "pkill autotiling; exit" & disown
