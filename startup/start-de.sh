#!/bin/bash
set -euo pipefail

MAX_RETRIES="${MAX_RETRIES:-20}"

SLEEP_TIME="${SLEEP_TIME:-1}"

export DISPLAY=:10

echo ">> Applying GNOME scaling settings"
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 1
gsettings set org.gnome.desktop.session idle-delay 0


echo ">> Launching GNOME session"
unset WAYLAND_DISPLAY
gnome-session