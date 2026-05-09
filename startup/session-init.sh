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
export WLR_BACKENDS=wayland
export WLR_RENDERER="${WLR_RENDERER:-pixman}"
export WLR_NO_HARDWARE_CURSORS=1
export GNOME_WAYLAND_DISPLAY="${GNOME_WAYLAND_DISPLAY:-wayland-gnome}"
export GNOME_X11_DISPLAY="${GNOME_X11_DISPLAY:-:1}"

GAMESCOPE_WIDTH="${GAMESCOPE_WIDTH:-1920}"
GAMESCOPE_HEIGHT="${GAMESCOPE_HEIGHT:-1080}"
GAMESCOPE_REFRESH="${GAMESCOPE_REFRESH:-60}"
export MUTTER_DEBUG_DUMMY_MODE_SPECS="${MUTTER_DEBUG_DUMMY_MODE_SPECS:-${GAMESCOPE_WIDTH}x${GAMESCOPE_HEIGHT}@${GAMESCOPE_REFRESH}.0}"
export MUTTER_DEBUG_NUM_DUMMY_MONITORS="${MUTTER_DEBUG_NUM_DUMMY_MONITORS:-1}"
export MUTTER_DEBUG_DUMMY_MONITOR_SCALES="${MUTTER_DEBUG_DUMMY_MONITOR_SCALES:-1}"

export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"
export MANGOHUD="${MANGOHUD:-1}"
export DXVK_FRAME_RATE=$((GAMESCOPE_REFRESH + 2))

echo ">> Restoring GNOME settings"
ORIG="$HOME/.config/dconf/user"
BACK="$HOME/.config/dconf/user.bak"
MONITORS_XML="$HOME/.config/monitors.xml"
MONITORS_BACK="$HOME/.config/monitors.xml.bak"

if [ -f "$ORIG" ]; then
    [ -f "$BACK" ] && cp "$BACK" "$ORIG" || cp "$ORIG" "$BACK"
else
    echo ">> No dconf settings found."
fi

if [ -f "$MONITORS_XML" ]; then
    [ -f "$MONITORS_BACK" ] || cp "$MONITORS_XML" "$MONITORS_BACK"
    rm -f "$MONITORS_XML"
fi

rm -f "$XDG_RUNTIME_DIR/$GNOME_WAYLAND_DISPLAY"

echo ">> Configuring sway session"
mkdir -p "$HOME/.config/sway"

cat > "$HOME/.config/sway/config" <<EOF
default_border none
output * resolution ${GAMESCOPE_WIDTH}x${GAMESCOPE_HEIGHT} position 0,0
seat * hide_cursor 0
exec swaybg -i /startup/zorin_logo.png -m fit -c "#FFFFFF"
exec /startup/start-de.sh
EOF

export $(dbus-launch)

echo ">> Setting up flatpak"
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo &> /logs/flatpak.log
flatpak override --user --filesystem="$HOME/.themes" &>> /logs/flatpak.log
flatpak override --user --filesystem="$HOME/.icons" &>> /logs/flatpak.log
flatpak override --user --socket=wayland &>> /logs/flatpak.log

echo ">> Starting pipewire session services"
pipewire &> /logs/pipewire.log &
wireplumber &> /logs/wireplumber.log &

echo ">> Starting sway"
exec sway --unsupported-gpu
