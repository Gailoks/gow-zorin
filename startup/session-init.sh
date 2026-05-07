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

export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
export MANGOHUD="${MANGOHUD:-1}"
export DXVK_FRAME_RATE=$((GAMESCOPE_REFRESH + 2))

echo ">> Restoring GNOME settings"
ORIG="$HOME/.config/dconf/user"
BACK="$HOME/.config/dconf/user.bak"

if [ -f "$ORIG" ]; then
    [ -f "$BACK" ] && cp "$BACK" "$ORIG" || cp "$ORIG" "$BACK"
else
    echo ">> No dconf settings found."
fi

echo ">> Configuring sway + Xwayland"
mkdir -p "$HOME/.config/sway"

cat > "$HOME/.config/sway/config" <<EOF
default_border none
output * resolution ${GAMESCOPE_WIDTH}x${GAMESCOPE_HEIGHT} position 0,0
exec /startup/start-de.sh
EOF

export $(dbus-launch)

echo ">> Setting up flatpak"
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo &> /logs/flatpak.log
flatpak override --user --filesystem="$HOME/.themes" &>> /logs/flatpak.log
flatpak override --user --filesystem="$HOME/.icons" &>> /logs/flatpak.log
flatpak override --user --socket=wayland &>> /logs/flatpak.log

echo ">> Starting sway"
exec dbus-run-session sway --unsupported-gpu
