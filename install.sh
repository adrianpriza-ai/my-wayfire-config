#!/bin/bash

# ============================================
# Cek Arch-based
# ============================================

if [ ! -f /etc/pacman.conf ] || ! command -v pacman &> /dev/null; then
    echo "Bukan Arch-based distro! Script ini hanya untuk Arch Linux."
    exit 1
fi

echo "Arch-based distro terdeteksi."

# ============================================
# Informasi
# ============================================

echo ""
echo "================================================"
echo "   Install Wayfire Config - adrianpriza-ai"
echo "================================================"
echo ""
echo "Script ini akan melakukan:"
echo "  - Masuk ke ~/my-wayfire-config/"
echo "  - Backup config lama (rename dengan -clone)"
echo "  - Copy config baru ke ~/.config/"
echo "  - Install package yang dibutuhkan"
echo ""
echo "astikan repo sudah di-clone ke ~/my-wayfire-config/"
echo ""

# ============================================
# Konfirmasi
# ============================================

read -p "Lanjutkan? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Dibatalkan."
    exit 0
fi

echo ""

# ============================================
# Pindah ke direktori repo
# ============================================

cd ~/my-wayfire-config/ || {
    echo "Folder ~/my-wayfire-config/ tidak ditemukan!"
    echo "Clone dulu: git clone git@github.com:adrianpriza-ai/my-wayfire-config.git ~/my-wayfire-config"
    exit 1
}

echo "Masuk ke ~/my-wayfire-config/"

# ============================================
# Backup config lama
# ============================================

echo ""
echo ">>> Mengecek config lama di ~/.config/..."

# Daftar folder/file yang dicek
CONFIG_ITEMS=(
    "eww"
    "gtklock"
    "kitty"
    "mako"
    "rofi"
    "swaylock"
    "waybar"
    "wayfire"
    "wayfire.ini"
)

for item in "${CONFIG_ITEMS[@]}"; do
    target="$HOME/.config/$item"
    if [ -e "$target" ]; then
        mv "$target" "${target}-clone"
        echo "Backup: $item → ${item}-clone"
    else
        echo "idak ada: $item, skip."
    fi
done

echo "Backup selesai."

# ============================================
# Copy config baru
# ============================================

echo ""
echo ">>> Copy config baru ke ~/.config/..."

cp -r ./config/* ~/.config/

echo "Config berhasil dicopy."

# ============================================
# Install Package
# ============================================

echo ""
read -p "Install package yang dibutuhkan? (y/n): " install_pkg
if [[ "$install_pkg" != "y" && "$install_pkg" != "Y" ]]; then
    echo "kip install package."
else
    echo ""
    echo ">>> Install package..."

    # ----------------------------------------
    # EDIT DAFTAR PACKAGE DI SINI
    # ----------------------------------------
    PACKAGES=(
        "wayfire"
        "waybar"
        "kitty"
        "rofi"
        "mako"
        # tambahkan package lain di sini
    )
    # ----------------------------------------

    sudo pacman -S --noconfirm "${PACKAGES[@]}"
    echo "Package berhasil diinstall."
fi

# ============================================

echo ""
echo "================================================"
echo "   Selesai! Config sudah terpasang."
echo "   Config lama disimpan dengan nama -clone"
echo "================================================"
