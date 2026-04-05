#!/bin/bash

INTERNAL="eDP-1"
EXTERNAL=$(xrandr | grep " connected" | grep -v "$INTERNAL" | awk '{print $1}' | head -n1)

MODE="$1"
if [ -z "$EXTERNAL" ]; then
    case "$MODE" in
        external|mirror|extend)
            notify-send "Display" "Tidak ada monitor eksternal"
            exit 1
            ;;
    esac
fi
case "$MODE" in
    mirror)
        xrandr --output "$EXTERNAL" --auto --same-as "$INTERNAL"
        ;;
    extend)
        xrandr --output "$EXTERNAL" --auto --right-of "$INTERNAL"
        ;;
    internal)
        xrandr --output "$EXTERNAL" --off --output "$INTERNAL" --auto
        ;;
    external)
        xrandr --output "$INTERNAL" --off --output "$EXTERNAL" --auto
        ;;
esac
