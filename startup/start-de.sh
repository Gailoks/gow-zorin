#!/bin/bash
set -euo pipefail
source /startup/tools.sh

info ">> Applying GNOME scaling settings"
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 1
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.interface cursor-size "${XCURSOR_SIZE}"
gsettings set org.gnome.desktop.interface cursor-theme "${XCURSOR_THEME}"

# Xwayland setup 
export DISPLAY=:10
Xwayland :10 -fakescreenfps 600 -verbose 3  -noTouchPointerEmulation &> /logs/xwayland.log & 
unset WAYLAND_DISPLAY

for i in $(seq 1 20); do
    if [ -S /tmp/.X11-unix/X10 ]; then
        break
    fi
    sleep 0.1
done

xrdb -merge &> /logs/xrdb.log <<EOF 
Xcursor.size: ${XCURSOR_SIZE}
Xcursor.theme: ${XCURSOR_THEME}
EOF

info ">> Launching gnome"
exec gnome-session --debug &> /logs/gnome-shell.log 
