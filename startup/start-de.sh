#!/bin/bash
set -euo pipefail
source /startup/tools.sh

info ">> Applying GNOME scaling settings"
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 1
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.interface cursor-size "${XCURSOR_SIZE}"
gsettings set org.gnome.desktop.interface cursor-theme "${XCURSOR_THEME}"
gsettings set org.gnome.mutter check-alive-timeout 0
gsettings set org.gnome.mutter draggable-border-width 0


# Xwayland setup 
export DISPLAY=:10
Xwayland :10 -fakescreenfps 600 -verbose 3  -noTouchPointerEmulation &> /logs/xwayland.log & 

export GNOME_WAYLAND_DISPLAY="${GNOME_WAYLAND_DISPLAY:-wayland-gnome}"
for i in $(seq 1 20); do
    if [ -S /tmp/.X11-unix/X10 ]; then
        break
    fi
    sleep 0.2
done
xrdb -merge &> /logs/xrdb.log <<EOF 
Xcursor.size: ${XCURSOR_SIZE}
Xcursor.theme: ${XCURSOR_THEME}
EOF

info ">> Launching nested GNOME Shell"
exec gnome-shell --nested --wayland --wayland-display="${GNOME_WAYLAND_DISPLAY}" --sm-disable &> /logs/gnome-shell.log & 
GNOME_SHELL_PID=$!

SOCKET_PATH="${XDG_RUNTIME_DIR}/${GNOME_WAYLAND_DISPLAY:?}"
for _ in $(seq 1 100); do
    [ -S "$SOCKET_PATH" ] && break
    sleep 0.1
done

dbus-update-activation-environment WAYLAND_DISPLAY="${GNOME_WAYLAND_DISPLAY}" DISPLAY="${GNOME_X11_DISPLAY:-:1}" XDG_CURRENT_DESKTOP XDG_SESSION_TYPE GDK_BACKEND QT_QPA_PLATFORM MOZ_ENABLE_WAYLAND
dbus-update-activation-environment GTK_IM_MODULE QT_IM_MODULE XMODIFIERS

wait "$GNOME_SHELL_PID"
