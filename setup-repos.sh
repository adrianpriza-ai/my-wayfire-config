#!/bin/bash

# ============================================
# Setup Chaotic-AUR & ArchLinuxCN
# ============================================

echo ">>> Setup Chaotic-AUR..."

# Import key & install keyring
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# Tambah repo ke pacman.conf
if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
    echo ">>> Chaotic-AUR ditambahkan."
else
    echo ">>> Chaotic-AUR sudah ada, skip."
fi

# ============================================

echo ">>> Setup ArchLinuxCN..."

# Tambah repo ke pacman.conf
if ! grep -q "\[archlinuxcn\]" /etc/pacman.conf; then
    echo -e "\n[archlinuxcn]\nServer = https://repo.archlinuxcn.org/\$arch" >> /etc/pacman.conf
    echo ">>> ArchLinuxCN ditambahkan."
else
    echo ">>> ArchLinuxCN sudah ada, skip."
fi

# Install keyring ArchLinuxCN
pacman -Sy --noconfirm archlinuxcn-keyring

# ============================================

echo ">>> Update database..."
pacman -Sy

echo ">>> Selesai! Chaotic-AUR & ArchLinuxCN siap dipakai."
