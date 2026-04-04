#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# ============================================
# Cek Arch-based
# ============================================

if [ ! -f /etc/pacman.conf ] || ! command -v pacman &> /dev/null; then
    echo "ERROR: Bukan Arch-based distro! Script ini hanya untuk Arch Linux."
    exit 1
fi

echo "OK: Arch-based distro terdeteksi."

# ============================================
# Informasi
# ============================================

echo ""
echo "================================================"
echo "   Install Wayfire Config - adrianpriza-ai"
echo "================================================"
echo ""
echo "Script ini akan melakukan:"
echo "  - Menggunakan direktori repo saat ini"
echo "  - Backup config lama (rename dengan -clone)"
echo "  - Copy config baru ke ~/.config/"
echo "  - Install package yang dibutuhkan"
echo ""
echo "PERHATIAN: Jalankan script ini dari dalam folder repo."
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

cd "$SCRIPT_DIR" || {
    echo "ERROR: Folder ~/my-wayfire-config/ tidak ditemukan!"
    echo "       Clone dulu: git clone git@github.com:adrianpriza-ai/my-wayfire-config.git ~/my-wayfire-config"
    exit 1
}

echo "OK: Menggunakan direktori repo: $SCRIPT_DIR"

# ============================================
# Backup config lama
# ============================================

if [ ! -d "./config" ]; then
    echo "ERROR: Folder config tidak ditemukan!"
    exit 1
fi

echo ""
echo ">>> Mengecek config lama di ~/.config/..."

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
timestamp=$(date +%Y%m%d-%H%M%S)

for item in "${CONFIG_ITEMS[@]}"; do
    target="$HOME/.config/$item"
    if [ -e "$target" ]; then
        mv "$target" "${target}-clone-$timestamp"
        echo "  Backup: $item -> ${item}-clone-$timestamp"
    else
        echo "  Tidak ada: $item, skip."
    fi
done

if [ -e "$HOME/.nanorc" ]; then
    mv "$HOME/.nanorc" "$HOME/.nanorc-clone-$timestamp"
    echo "  Backup: .nanorc -> .nanorc-clone-$timestamp"
fi

echo "OK: Backup selesai."

# ============================================
# Copy config baru
# ============================================

echo ""
echo ">>> Copy config baru ke ~/.config/..."

mkdir -p "$HOME/.config"

if command -v rsync &> /dev/null; then
    echo "Menggunakan rsync..."
    rsync -av ./config/ "$HOME/.config/"
else
    echo "rsync tidak ditemukan, fallback ke cp..."
    cp -rf ./config/* "$HOME/.config/"
fi

if [ -f "./config/nanorc" ]; then
    cp ./config/nanorc ~/.nanorc
    echo "OK: .nanorc berhasil dicopy."
fi

echo "OK: Config berhasil dicopy."

# ============================================
# Install Package
# ============================================

echo ""
read -p "Install package yang dibutuhkan? (y/n): " install_pkg
if [[ "$install_pkg" != "y" && "$install_pkg" != "Y" ]]; then
    echo "Skip install package."
else
    if ! sudo -v &> /dev/null; then
        echo "ERROR: Butuh akses sudo untuk install package. Skip."
    else
        echo ""
    echo ""
    echo ">>> Mengecek package manager yang tersedia..."

    # Cek Chaotic-AUR
    HAS_CHAOTIC=false
    if grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
        HAS_CHAOTIC=true
        echo "OK: Chaotic-AUR ditemukan, pakai pacman."
    else
        echo "INFO: Chaotic-AUR tidak ditemukan."
    fi

    # Cek yay (fallback)
    HAS_YAY=false
    if command -v yay &> /dev/null; then
        HAS_YAY=true
        echo "OK: yay ditemukan, pakai yay sebagai fallback."
    else
        echo "INFO: yay tidak ditemukan."
    fi

    if [ "$HAS_CHAOTIC" = false ] && [ "$HAS_YAY" = false ]; then
        echo "PERINGATAN: Chaotic-AUR dan yay tidak tersedia."
        echo "            Beberapa package mungkin tidak bisa diinstall."
        echo "            Skip install package."
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

        if [ "$HAS_CHAOTIC" = true ]; then
            sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
        elif [ "$HAS_YAY" = true ]; then
            yay -S --needed --noconfirm "${PACKAGES[@]}"
        fi

        echo "OK: Package berhasil diinstall."
    fi
    fi
fi

# ============================================

echo ""
echo "================================================"
echo "  Selesai! Config sudah terpasang."
echo "  Config lama disimpan dengan nama -clone"
echo "================================================"
