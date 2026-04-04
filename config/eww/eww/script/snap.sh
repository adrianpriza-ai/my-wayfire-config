#!/bin/bash

# 1. Tutup widget Eww sebelum mengambil gambar
eww close example

# Tentukan lokasi file
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

# 2. Ambil screenshot (keluar jika dibatalkan)
if ! grim -g "$(slurp)" "$FILE"; then
    eww open example
    exit 1
fi

# 3. Dialog Zenity dengan tombol aksi
# Tombol OK (0) -> Copy & Delete
# Tombol Cancel (1) -> Save (biarkan file tetap ada)
zenity --question \
    --title="Screenshot" \
    --text="Pilih tindakan untuk hasil tangkapan layar:" \
    --ok-label="Copy + Delete" \
    --cancel-label="Save" \
    --width=300

# Cek hasil klik pengguna
if [ $? -eq 0 ]; then
    # Jika pilih Copy + Delete
    wl-copy < "$FILE"
    rm "$FILE"
    notify-send "Screenshot" "Tersalin ke clipboard & file dihapus"
else
    # Jika pilih Save (atau tekan Esc/tutup jendela)
    notify-send "Screenshot" "Tersimpan di $FILE"
fi

# 4. Buka kembali widget Eww
eww open example
