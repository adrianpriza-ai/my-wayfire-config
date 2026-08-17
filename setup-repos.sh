#!/bin/bash
set -euo pipefail

# ============================================
# Prerequisites check
# ============================================

if ! sudo -v &> /dev/null; then
    echo "ERROR: sudo access required."
    exit 1
fi
echo "OK: sudo access granted."

if [ ! -f /etc/pacman.conf ] || ! command -v pacman &> /dev/null; then
    echo "ERROR: Not Arch-based. This script is for Arch Linux only."
    exit 1
fi
echo "OK: Arch-based distro detected."

if ! ping -c 1 archlinux.org &> /dev/null; then
    echo "ERROR: No internet connection."
    exit 1
fi

# ============================================
# Info and selection
# ============================================

echo ""
echo "================================================"
echo "   Setup Repo - Chaotic-AUR / ArchLinuxCN / yay"
echo "================================================"
echo ""
echo "Options:"
echo "  1) Chaotic-AUR + ArchLinuxCN"
echo "  2) yay (AUR helper)"
echo "  3) Both"
echo ""
read -r -p "Choice (1/2/3): " choice

case "$choice" in
    1|2|3) ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

echo ""
echo "Will do:"
case "$choice" in
    1) echo "  - Setup Chaotic-AUR"; echo "  - Setup ArchLinuxCN" ;;
    2) echo "  - Install yay from AUR" ;;
    3) echo "  - Setup Chaotic-AUR"; echo "  - Setup ArchLinuxCN"; echo "  - Install yay from AUR" ;;
esac

echo ""
read -r -p "Continue? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""

# ============================================
# Backup pacman.conf
# ============================================

timestamp=$(date +%Y%m%d-%H%M%S)
sudo cp /etc/pacman.conf "/etc/pacman.conf.backup-${timestamp}"
echo "OK: pacman.conf backed up as pacman.conf.backup-${timestamp}"

# ============================================
# Setup Chaotic-AUR
# ============================================

setup_chaotic() {
    echo ">>> Setting up Chaotic-AUR..."

    if grep -q "^\[chaotic-aur\]" /etc/pacman.conf; then
        echo "INFO: Chaotic-AUR already configured, skipping."
        return
    fi

    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null || {
        echo "ERROR: Failed to write to pacman.conf"
        exit 1
    }
    echo "OK: Chaotic-AUR added."
}

# ============================================
# Setup ArchLinuxCN
# ============================================

setup_archlinuxcn() {
    echo ">>> Setting up ArchLinuxCN..."

    if grep -q "^\[archlinuxcn\]" /etc/pacman.conf; then
        echo "INFO: ArchLinuxCN already configured, skipping."
        return
    fi

    echo -e "\n[archlinuxcn]\nServer = https://repo.archlinuxcn.org/\$arch" | sudo tee -a /etc/pacman.conf > /dev/null || {
        echo "ERROR: Failed to write to pacman.conf"
        exit 1
    }
    sudo pacman -Sy --noconfirm archlinuxcn-keyring
    echo "OK: ArchLinuxCN added."
}

# ============================================
# Install yay
# ============================================

setup_yay() {
    echo ">>> Setting up yay..."

    if command -v yay &> /dev/null; then
        echo "INFO: yay already installed, skipping."
        return
    fi

    if ! command -v git &> /dev/null; then
        echo ">>> Installing git..."
        sudo pacman -S --needed --noconfirm git
    fi

    if ! pacman -Qi base-devel &> /dev/null; then
        echo ">>> Installing base-devel..."
        sudo pacman -S --needed --noconfirm base-devel
    fi

    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"

    if command -v yay &> /dev/null; then
        echo "OK: yay installed."
    else
        echo "ERROR: yay installation failed."
    fi
}

# ============================================
# Run
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
# Update pacman databases
# ============================================

echo ""
echo ">>> Updating pacman databases..."
sudo pacman -Sy --noconfirm

echo ""
echo "================================================"
echo "  Done! Repos ready."
echo "================================================"
