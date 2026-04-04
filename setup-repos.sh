#!/bin/bash

# ============================================
# Cek Arch-based
# ============================================

if [ ! -f /etc/pacman.conf ] || ! command -v pacman &> /dev/null; then
    echo "Bukan Arch-based distro! Script ini hanya untuk Arch Linux."
    exit 1
fi

echo "Arch-based distro terdeteksi. lanjut setup..."

# ============================================
# Informasi
# ============================================

echo ""
echo "================================================"
echo "   Setup Chaotic-AUR & ArchLinuxCN"
echo "================================================"
echo ""
echo "Script ini akan melakukan:"
echo "  - Menambahkan repo Chaotic-AUR ke pacman.conf"
echo "  - Menambahkan repo ArchLinuxCN ke pacman.conf"
echo "  - Import & install keyring kedua repo"
echo "  - Update database pacman"
echo ""
echo "Script ini membutuhkan akses root (sudo)."
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
# Setup Chaotic-AUR
# ============================================

echo ">>> Setup Chaotic-AUR..."

pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
    echo "Chaotic-AUR ditambahkan."
else
    echo "Chaotic-AUR sudah ada, skip."
fi

# ============================================
# Setup ArchLinuxCN
# ============================================

echo ""
echo ">>> Setup ArchLinuxCN..."

if ! grep -q "\[archlinuxcn\]" /etc/pacman.conf; then
    echo -e "\n[archlinuxcn]\nServer = https://repo.archlinuxcn.org/\$arch" >> /etc/pacman.conf
    echo "ArchLinuxCN ditambahkan."
else
    echo "ArchLinuxCN sudah ada, skip."
fi

pacman -Sy --noconfirm archlinuxcn-keyring

# ============================================

echo ""
echo ">>> Update database pacman..."
pacman -Sy

echo ""
echo "================================================"
echo "Selesai! Chaotic-AUR & ArchLinuxCN siap dipakai."
echo "================================================"
