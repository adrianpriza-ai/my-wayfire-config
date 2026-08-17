#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================
# Detect distro
# ============================================

IS_ARCH=false
if [ -f /etc/pacman.conf ] && command -v pacman &> /dev/null; then
    IS_ARCH=true
    echo "OK: Arch-based distro detected."
else
    echo "WARNING: Not an Arch-based distro."
    echo "         Config copy will still work."
    echo "         Package install will be skipped."
    echo ""
    read -r -p "Continue without package manager? (y/n): " arch_confirm
    if [[ "$arch_confirm" != "y" && "$arch_confirm" != "Y" ]]; then
        echo "Aborted."
        exit 0
    fi
fi

if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
    echo "INFO: Not in a Wayland session."
    echo "      This config will activate when you log into Wayfire (Wayland)."
fi

# ============================================
# Confirmation
# ============================================

echo ""
echo "================================================"
echo "   Install Wayfire Config - adrianpriza-ai"
echo "================================================"
echo ""
echo "This script will:"
echo "  - Backup existing configs (rename with -clone suffix)"
echo "  - Copy new configs to ~/.config/"
echo "  - Install required packages (optional)"
echo ""
echo "Run this script from inside the repo folder."
echo ""

read -r -p "Continue? (y/n): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""

# ============================================
# Ensure we're in the repo
# ============================================

cd "$SCRIPT_DIR" || {
    echo "ERROR: Can't enter repo directory: $SCRIPT_DIR"
    exit 1
}

echo "OK: Repo directory: $SCRIPT_DIR"

# ============================================
# Validate config dir
# ============================================

if [ ! -d "./config" ]; then
    echo "ERROR: ./config directory not found!"
    exit 1
fi

# ============================================
# Backup existing configs
# ============================================

echo ""
echo ">>> Checking existing configs in ~/.config/..."

CONFIG_ITEMS=(
    "eww"
    "fastfetch"
    "fish"
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
        mv "$target" "${target}-clone-${timestamp}" || echo "Failed to backup $item"
        echo "  Backed up: $item -> ${item}-clone-${timestamp}"
    else
        echo "  Not found: $item, skipping."
    fi
done

if [ -e "$HOME/.nanorc" ]; then
    mv "$HOME/.nanorc" "$HOME/.nanorc-clone-${timestamp}"
    echo "  Backed up: .nanorc -> .nanorc-clone-${timestamp}"
fi

echo "OK: Backup complete."

# ============================================
# Copy new configs
# ============================================

echo ""
echo ">>> Copying new configs to ~/.config/..."

mkdir -p "$HOME/.config"

if command -v rsync &> /dev/null; then
    echo "Using rsync..."
    rsync -a ./config/ "$HOME/.config/"
else
    echo "rsync not found, falling back to cp..."
    cp -rf ./config/. "$HOME/.config/"
fi

if [ -f "./config/nanorc" ]; then
    cp ./config/nanorc "$HOME/.nanorc"
    echo "OK: .nanorc copied."
fi

echo "OK: Configs copied."

# ============================================
# Install packages
# ============================================

echo ""
read -r -p "Install required packages? (y/n): " install_pkg
if [[ "$install_pkg" != "y" && "$install_pkg" != "Y" ]]; then
    echo "Skipping package install."
elif [ "$IS_ARCH" = false ]; then
    echo "WARNING: Not Arch-based. Install packages manually."
else
    if ! sudo -v &> /dev/null; then
        echo "ERROR: sudo access required for package install. Skipping."
    else
        echo ""
        echo ">>> Checking available package managers..."

        HAS_CHAOTIC=false
        if grep -q "^\[chaotic-aur\]" /etc/pacman.conf; then
            HAS_CHAOTIC=true
            echo "OK: Chaotic-AUR found, using pacman."
        else
            echo "INFO: Chaotic-AUR not found."
        fi

        HAS_YAY=false
        if command -v yay &> /dev/null; then
            HAS_YAY=true
            echo "OK: yay found."
        else
            echo "INFO: yay not found."
        fi

        if [ "$HAS_CHAOTIC" = false ] && [ "$HAS_YAY" = false ]; then
            echo "WARNING: Neither Chaotic-AUR nor yay available."
            echo "         Some packages may not install."
            echo "         Skipping package install."
        else
            echo ""
            echo ">>> Installing packages..."

            PACKAGES=(
                "wayfire"
                "waybar"
                "kitty"
                "rofi"
                "mako"
                "xdg-desktop-portal-wlr"
                "wf-shell"
                "swaybg"
            )

            if [ "$HAS_CHAOTIC" = true ]; then
                sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
            elif [ "$HAS_YAY" = true ]; then
                yay -S --needed --noconfirm "${PACKAGES[@]}"
            fi

            echo "OK: Packages installed."
        fi
    fi
fi

# ============================================

echo ""
echo "================================================"
echo "  Done! Config installed."
echo "  Old configs saved with -clone suffix."
echo "================================================"
