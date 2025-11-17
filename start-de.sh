
COUNT=0
while [ $COUNT -lt 20 ]; do
  if env DISPLAY=:9 xrandr --output XWAYLAND0 --mode "${GAMESCOPE_WIDTH}x${GAMESCOPE_HEIGHT}" >/dev/null 2>&1; then
    exit 0
  fi
  COUNT=$((COUNT+1))
  sleep 1
done
exit 1