#!/bin/bash
set -euo pipefail

echo ">> Preparing directories"
mkdir -p /logs /tmp/sockets /var/run/dbus /tmp/.X11-unix
chmod 777 -R /logs
chmod 0700 -R /tmp/sockets
chmod +t /tmp/sockets
chmod 1777 /tmp/.X11-unix

echo ">> Running provisioning scripts"
/setup-user.sh
/setup-devices.sh
/setup-nvidia.sh
/setup-config.sh

chown "$UNAME:$UNAME" -R /tmp/sockets /home/"$UNAME"

echo ">> Setup chrome sandbox permissions"
chmod 4755 /opt/Heroic/chrome-sandbox

echo ">> Setup Heroic prefixes"
mkdir -p "$HOME/Games/Heroic" "$HOME/Prefixes"
chown "$UNAME:$UNAME" "$HOME/Prefixes"
ln -sf "$HOME/Prefixes" "$HOME/Games/Heroic/Prefixes"

echo ">> Starting dbus daemon"
service dbus start &> /logs/dbus.log


if [ -d /custom-scripts ]; then
    echo ">> Executing custom scripts"
    for script in /custom-scripts/*; do
        [ -f "$script" ] && bash "$script" || true
    done
fi

# ---- START USER SESSION ----

echo ">> Preparing user session"
exec gosu "$UNAME" /session-init.sh
