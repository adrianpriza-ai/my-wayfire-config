#!/bin/bash

while true; do
    EXTRA_EWW=$(pgrep -f "eww open" | wc -l)
    if [ "$EXTRA_EWW" -gt 0 ]; then
        killall -9 -q eww
        sleep 0.5
        eww daemon &
    fi
    sleep 2
done
