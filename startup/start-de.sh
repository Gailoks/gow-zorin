#!/bin/bash
set -euo pipefail

echo ">> Applying GNOME scaling settings"
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 1
gsettings set org.gnome.desktop.session idle-delay 0

echo ">> Launching nested GNOME Shell"
gnome-shell --nested --wayland-display="${GNOME_WAYLAND_DISPLAY:?}" &
GNOME_SHELL_PID=$!

SOCKET_PATH="${XDG_RUNTIME_DIR}/${GNOME_WAYLAND_DISPLAY:?}"
for _ in $(seq 1 100); do
    [ -S "$SOCKET_PATH" ] && break
    sleep 0.1
done

dbus-update-activation-environment WAYLAND_DISPLAY="${GNOME_WAYLAND_DISPLAY}" DISPLAY="${GNOME_X11_DISPLAY:-:1}" XDG_CURRENT_DESKTOP XDG_SESSION_TYPE GDK_BACKEND QT_QPA_PLATFORM MOZ_ENABLE_WAYLAND
dbus-update-activation-environment GTK_IM_MODULE QT_IM_MODULE XMODIFIERS

wait "$GNOME_SHELL_PID"
