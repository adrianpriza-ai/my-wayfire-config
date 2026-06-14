#!/bin/bash
eww close example
eww close media-player
eww close cal
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"
if ! grim -g "$(slurp)" "$FILE"; then
    eww open example
    eww open media-player
    exit 1
fi
zenity --question --title="Screenshot" --text="Pilih tindakan untuk hasil tangkapan layar:" --ok-label="Copy + Delete" --cancel-label="Save" --width=300
if [ $? -eq 0 ]; then
    wl-copy < "$FILE"
    rm "$FILE"
    notify-send "Screenshot" "Tersalin ke clipboard & file dihapus"
else
    notify-send "Screenshot" "Tersimpan di $FILE"
fi
eww open example
eww open media-player
