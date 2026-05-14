#!/bin/bash
set -euo pipefail
source /startup/tools.sh

info ">> Preparing directories"
mkdir -p /logs /tmp/sockets /var/run/dbus /tmp/.X11-unix /run/user /tmp/.ICE-unix
chmod 777 -R /logs
chmod 0700 -R /tmp/sockets
chmod +t /tmp/sockets
chmod 1777 /tmp/.X11-unix /tmp/.ICE-unix

info ">> Running provisioning scripts"
/startup/setup-user.sh
/startup/setup-devices.sh
/startup/setup-nvidia.sh
/startup/setup-config.sh

install -d -m 0700 -o "$PUID" -g "$PGID" "/run/user/$PUID"

chown "$UNAME:$UNAME" -R /tmp/sockets 

info ">> Setup chrome sandbox permissions"
chmod 4755 /opt/Heroic/chrome-sandbox

info ">> Setup Heroic prefixes"
mkdir -p "$HOME/Games/Heroic" "$HOME/Prefixes" 
chown "$UNAME:$UNAME" "$HOME/Prefixes"
chown "$UNAME:$UNAME" "$HOME/Games/Heroic"
ln -sf "$HOME/Prefixes" "$HOME/Games/Heroic/Prefixes"

info ">> Create autostart directory"
mkdir -p "$HOME/.config/autostart"
cp /startup/set-resolution.desktop "$HOME/.config/autostart/set-resolution.desktop"
chmod 777 "$HOME/.config/autostart/set-resolution.desktop"
chown "$UNAME:$UNAME" "$HOME/.config/autostart" -R

info ">> Starting dbus daemon"
dbus-daemon --system --address=unix:path=/run/dbus/system_bus_socket --fork &> /logs/dbus.log

if [ -x /usr/lib/systemd/systemd-logind ]; then
    info ">> Starting logind daemon"
    /usr/lib/systemd/systemd-logind &> /logs/logind.log &
fi


if [ -d /custom-scripts ]; then
    info ">> Executing custom scripts"
	echo "" > /logs/scripts.log
    for script in /custom-scripts/*; do
        [ -f "$script" ] && bash "$script" &>> /logs/scripts.log || true
    done
fi

# ---- START USER SESSION ----

info ">> Preparing user session"
exec gosu "$UNAME" /startup/session-init.sh
