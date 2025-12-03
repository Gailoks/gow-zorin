#!/bin/bash
set -euo pipefail

MAX_RETRIES="${MAX_RETRIES:-20}"
SLEEP_TIME="${SLEEP_TIME:-0.4}"

echo ">> start-de.sh: Waiting for {} mode..."

for ((i=1; i<=MAX_RETRIES; i++)); do
	if xrandr --output XWAYLAND0 --mode "${GAMESCOPE_WIDTH}x${GAMESCOPE_HEIGHT}" &> /dev/null; then
		echo ">> start-de.sh: Mode set successfully"
		break
	fi
	sleep "$SLEEP_TIME"
done

if [ "$i" -gt "$MAX_RETRIES" ]; then
	echo "start-de.sh: Failed to set mode after $MAX_RETRIES attempts" >&2
fi


echo ">> start-de.sh: Launching GNOME session"
unset WAYLAND_DISPLAY
exec gnome-session
