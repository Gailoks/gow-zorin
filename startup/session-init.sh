#!/bin/bash
set -euo pipefail

echo ">> Updating XDG user dirs"
xdg-user-dirs-update &> /logs/xdg.log

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/usr/local/share:/usr/share"
export XDG_CURRENT_DESKTOP=zorin:GNOME
export DE=zorin
export DESKTOP_SESSION=zorin
export GNOME_SHELL_SESSION_MODE=zorin
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_CLASS=user
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

GAMESCOPE_WIDTH="${GAMESCOPE_WIDTH:-1920}"
GAMESCOPE_HEIGHT="${GAMESCOPE_HEIGHT:-1080}"
GAMESCOPE_REFRESH="${GAMESCOPE_REFRESH:-60}"
export MUTTER_DEBUG_DUMMY_MODE_SPECS="${MUTTER_DEBUG_DUMMY_MODE_SPECS:-${GAMESCOPE_WIDTH}x${GAMESCOPE_HEIGHT}@${GAMESCOPE_REFRESH}.0}"
export MUTTER_DEBUG_NUM_DUMMY_MONITORS="${MUTTER_DEBUG_NUM_DUMMY_MONITORS:-1}"
export MUTTER_DEBUG_DUMMY_MONITOR_SCALES="${MUTTER_DEBUG_DUMMY_MONITOR_SCALES:-1}"

export MUTTER_DEBUG_FORCE_KMS_MODE=simple
export CLUTTER_PAINT=disable-clipped-redraws:disable-culling
export MUTTER_DEBUG_ENABLE_ATOMIC_KMS=0

export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
export MUTTER_DEBUG_DISABLE_HW_CURSORS=1
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"

export MANGOHUD="${MANGOHUD:-1}"
export DXVK_FRAME_RATE=${GAMESCOPE_REFRESH}

export $(dbus-launch)

echo ">> Setting up flatpak"
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo &> /logs/flatpak.log
flatpak override --user --filesystem="$HOME/.themes" &>> /logs/flatpak.log
flatpak override --user --filesystem="$HOME/.icons" &>> /logs/flatpak.log
flatpak override --user --socket=wayland --socket=fallback-x11 --device=dri &>> /logs/flatpak.log


echo ">> Starting pipewire session services"
pipewire &> /logs/pipewire.log &
wireplumber &> /logs/wireplumber.log &


echo ">> Applying GNOME scaling settings"
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 1
gsettings set org.gnome.desktop.session idle-delay 0

echo ">> Launching Xwayland"
export DISPLAY=:10
exec Xwayland :10 -fakescreenfps 600 -verbose 3 &
echo ">> Launching nested GNOME Shell"
dbus-run-session -- gnome-shell --nested --wayland &
GNOME_SHELL_PID=$!
wait "$GNOME_SHELL_PID"
echo ">> Exiting session"