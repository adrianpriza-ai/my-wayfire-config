# my-wayfire-config (NOT TESTED YET)

Konfigurasi desktop pribadi berbasis Wayfire + Wayland untuk Arch Linux dan Arch-based lainnya.

---

## Tampilan

> Screenshot

![Screenshot](assets/frame-1.png)


![Screenshot](assets/frame-2.png)

---

## Dependensi

| Package | Keterangan |
|---|---|
| wayfire | Wayland compositor |
| waybar | Status bar |
| kitty | Terminal emulator |
| rofi | App launcher |
| mako | Notification daemon |
| swaylock | Lock screen |
| gtklock | Lock screen (GTK) |
| eww | Widget system |
| xdg-desktop-portal-wlr | Portal (screen share, file picker) |

> Sebagian package tersedia di Chaotic-AUR. Jalankan `setup_repos.sh` terlebih dahulu.

---

## Instalasi

### 1. Clone repo

```bash
git clone https://github.com/adrianpriza-ai/my-wayfire-config.git ~/my-wayfire-config
cd ~/my-wayfire-config
```

### 2. Setup repo (opsional tapi direkomendasikan)

Jalankan script ini untuk menambahkan Chaotic-AUR, ArchLinuxCN, dan/atau yay:

```bash
chmod +x setup_repos.sh
./setup_repos.sh
```

Pilihan yang tersedia:
```
1) Chaotic-AUR + ArchLinuxCN
2) yay
3) Keduanya
```

### 3. Install config

```bash
chmod +x install.sh
./install.sh
```

Script ini akan:
- Backup config lama di `~/.config/` dengan suffix `-clone-YYYYMMDD-HHMMSS`
- Copy config baru ke `~/.config/`
- Install package yang dibutuhkan (opsional)

---

## Struktur Config

```
config/
├── eww/          # Widget system (action center, media player, dll)
├── gtklock/      # GTK lock screen
├── kitty/        # Terminal
├── mako/         # Notifikasi
├── rofi/         # App launcher
├── swaylock/     # Lock screen
├── waybar/       # Status bar
├── wayfire/      # Wayfire icons
└── wayfire.ini   # Konfigurasi utama Wayfire
```

---

## Script

| Script | Fungsi |
|---|---|
| `setup_repos.sh` | Setup Chaotic-AUR, ArchLinuxCN, dan/atau yay |
| `install.sh` | Backup config lama, copy config baru, install package |

---

## Restore Config Lama

Jika ingin kembali ke config sebelumnya:

```bash
# Contoh restore kitty
mv ~/.config/kitty-clone-YYYYMMDD-HHMMSS ~/.config/kitty

# Contoh restore waybar
mv ~/.config/waybar-clone-YYYYMMDD-HHMMSS ~/.config/waybar
```

---

## ⌨️ Shortcuts

### 🖥️ Launch & Apps
| Shortcut | Aksi |
|--------|------|
| `Ctrl + Alt + T` | Buka terminal (kitty) |
| `Super + Space` | Launcher (rofi) |
| `Super + E` | File manager (thunar) |
| `Super + B` | Browser (firefox) |

### 📸 Screenshot
| Shortcut | Aksi |
|--------|------|
| `Print` | Screenshot full |
| `Super + Shift + S` | Screenshot area (grim + satty) |

### 🔊 Audio & 💡 Brightness
| Shortcut | Aksi |
|--------|------|
| `Volume Up / Down` | Atur volume |
| `Mute` | Toggle mute |
| `Brightness Up / Down` | Atur kecerahan |

### 🪟 Window Management
| Shortcut | Aksi |
|--------|------|
| `Super + Q` | Close window |
| `Super + F` | Fullscreen |
| `Super + M` | Maximize |
| `Super + H` | Minimize |
| `Super + T` | Always on top |

### 🧩 Window Tiling (Grid)
| Shortcut | Aksi |
|--------|------|
| `Super + ← / →` | Snap kiri / kanan |
| `Super + ↑ / ↓` | Snap atas / bawah |
| `Super + Shift + Arrow` | Snap ke sudut |

### 🔄 Workspace & Overview
| Shortcut | Aksi |
|--------|------|
| `Alt + Tab` | Next window |
| `Alt + Shift + Tab` | Previous window |
| `Super + Tab` | Expo |
| `Super + W` | Scale (overview) |

### ⚙️ System
| Shortcut | Aksi |
|--------|------|
| `Ctrl + Alt + Delete` | Power menu |
| `Super + A` | Action center (eww) |

---

## Catatan

- Distro yang didukung: Arch Linux, dan Arch-based lainnya
- Compositor: Wayfire (Wayland)
- Resolusi yang digunakan: 1366x768
- Dibuat dengan bahasa Indonesia

## Overview

- Compositor: Wayfire (Wayland)
- Shell: Custom (waybar + eww)
- Launcher: rofi
- Target: Low-end hardware (1366x768)
- Screenshot: grim + satty
- Volume: pactl (PipeWire / PulseAudio)
- Brightness: brightnessctl
- Action center: eww

## Troubleshooting

- Jika rofi tidak muncul:
  Pastikan Wayland support aktif atau coba alternatif seperti wofi/fuzzel
