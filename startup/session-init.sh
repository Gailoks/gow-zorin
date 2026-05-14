#!/bin/bash
source /startup/tools.sh
set -euo pipefail

info ">> Updating XDG user dirs"
xdg-user-dirs-update &> /logs/xdg.log


info ">> Restoring GNOME settings"
ORIG="$HOME/.config/dconf/user"
BACK="$HOME/.config/dconf/user.bak"

if [ -f "$ORIG" ]; then
    [ -f "$BACK" ] && cp "$BACK" "$ORIG" || cp "$ORIG" "$BACK"
else
    warn ">> No dconf settings found."
fi

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share:/usr/local/share:/usr/share"
export XDG_CURRENT_DESKTOP=zorin:GNOME
export DE=zorin
export DESKTOP_SESSION=zorin
export GNOME_SHELL_SESSION_MODE=zorin
export XDG_SESSION_TYPE=x11
export XDG_SESSION_CLASS=user
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

export $(dbus-launch)

export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORM=xcb
export GDK_BACKEND=x11
export MOZ_ENABLE_WAYLAND=0
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
export MUTTER_DEBUG_DISABLE_HW_CURSORS=1
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS="@im=ibus"
export MANGOHUD="${MANGOHUD:-1}"
export DXVK_FRAME_RATE=${GAMESCOPE_REFRESH}


# Cursor settings
export XCURSOR_SIZE=24
export XCURSOR_THEME=Adwaita

info ">> Setting up flatpak"
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo &> /logs/flatpak.log
flatpak override --user --filesystem="$HOME/.themes" &>> /logs/flatpak.log
flatpak override --user --filesystem="$HOME/.icons" &>> /logs/flatpak.log
flatpak override --user --socket=x11 --device=dri --env=XCURSOR_THEME="${XCURSOR_THEME}" --env=XCURSOR_SIZE="${XCURSOR_SIZE}" &>> /logs/flatpak.log

info ">> Configuring sway session"
mkdir -p "$HOME/.config/sway"

cat > "$HOME/.config/sway/config" <<EOF
default_border none
output * resolution ${GAMESCOPE_WIDTH}x${GAMESCOPE_HEIGHT} position 0,0
seat * hide_cursor 0
exec swaybg -i /startup/zorin_logo.png -m fit -c "#FFFFFF"
exec /startup/start-de.sh
EOF

