#!/bin/bash

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
echo "   Setup Repo - Chaotic-AUR / ArchLinuxCN / yay"
echo "================================================"
echo ""
echo "Script ini dapat melakukan:"
echo "  1. Setup Chaotic-AUR + ArchLinuxCN"
echo "  2. Install yay (AUR helper)"
echo "  3. Keduanya"
echo ""

# ============================================
# Pilihan
# ============================================

echo "Pilih opsi:"
echo "  1) Chaotic-AUR + ArchLinuxCN"
echo "  2) yay"
echo "  3) Keduanya"
echo ""
read -p "Pilihan (1/2/3): " choice

case "$choice" in
    1|2|3) ;;
    *)
        echo "ERROR: Pilihan tidak valid."
        exit 1
        ;;
esac

echo ""
echo "Yang akan dilakukan:"
case "$choice" in
    1)
        echo "  - Setup Chaotic-AUR"
        echo "  - Setup ArchLinuxCN"
        ;;
    2)
        echo "  - Install yay dari AUR"
        ;;
    3)
        echo "  - Setup Chaotic-AUR"
        echo "  - Setup ArchLinuxCN"
        echo "  - Install yay dari AUR"
        ;;
esac

echo ""
read -p "Lanjutkan? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Dibatalkan."
    exit 0
fi

echo ""

# ============================================
# Fungsi: Setup Chaotic-AUR
# ============================================

setup_chaotic() {
    echo ">>> Setup Chaotic-AUR..."

    if grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
        echo "INFO: Chaotic-AUR sudah ada, skip."
    else
        sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
        sudo pacman-key --lsign-key 3056513887B78AEB
        sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
        sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
        echo "OK: Chaotic-AUR ditambahkan."
    fi
}

# ============================================
# Fungsi: Setup ArchLinuxCN
# ============================================

setup_archlinuxcn() {
    echo ">>> Setup ArchLinuxCN..."

    if grep -q "\[archlinuxcn\]" /etc/pacman.conf; then
        echo "INFO: ArchLinuxCN sudah ada, skip."
    else
        echo -e "\n[archlinuxcn]\nServer = https://repo.archlinuxcn.org/\$arch" | sudo tee -a /etc/pacman.conf > /dev/null
        sudo pacman -Sy --noconfirm archlinuxcn-keyring
        echo "OK: ArchLinuxCN ditambahkan."
    fi
}

# ============================================
# Fungsi: Install yay
# ============================================

setup_yay() {
    echo ">>> Setup yay..."

    if command -v yay &> /dev/null; then
        echo "INFO: yay sudah terinstall, skip."
        return
    fi

    # Cek dependensi
    if ! command -v git &> /dev/null; then
        echo ">>> Install git..."
        sudo pacman -S --noconfirm git
    fi

    if ! command -v base-devel &> /dev/null; then
        echo ">>> Install base-devel..."
        sudo pacman -S --noconfirm base-devel
    fi

    # Clone & build yay
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    cd "$tmpdir/yay" || exit 1
    makepkg -si --noconfirm
    cd ~ || exit 1
    rm -rf "$tmpdir"

    if command -v yay &> /dev/null; then
        echo "OK: yay berhasil diinstall."
    else
        echo "ERROR: yay gagal diinstall."
    fi
}

# ============================================
# Jalankan sesuai pilihan
# ============================================

case "$choice" in
    1)
        setup_chaotic
        echo ""
        setup_archlinuxcn
        ;;
    2)
        setup_yay
        ;;
    3)
        setup_chaotic
        echo ""
        setup_archlinuxcn
        echo ""
        setup_yay
        ;;
esac

# ============================================
# Update database
# ============================================

echo ""
echo ">>> Update database pacman..."
sudo pacman -Sy

echo ""
echo "================================================"
echo "  Selesai! Repo siap dipakai."
echo "================================================"
