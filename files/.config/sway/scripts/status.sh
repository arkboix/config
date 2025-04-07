#!/usr/bin/env sh

while true; do
    echo "Kernel: $(uname -r) | CPU: $(top -bn1 | awk '/^%Cpu/{print $2 "%"}') | Memory: $(free -h | awk '/^Mem/ {print $3 "/" $2}') | Battery: $(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "N/A")% | $(date '+%a %b %d %Y')"
    sleep 1
done
