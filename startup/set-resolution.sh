#!/bin/bash
DISPLAY="${DISPLAY:-:10}"

xrandr --output XWAYLAND0 --mode "${GAMESCOPE_WIDTH}x${GAMESCOPE_HEIGHT}"
