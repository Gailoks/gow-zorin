#!/usr/bin/env bash

set -e

echo ">> Exec device groups"
# make sure we're in the right groups to use all the required devices
# we're actually relying on word splitting for this call, so disable the
# warning from shellcheck
# shellcheck disable=SC2086
/startup/ensure-groups.sh ${GOW_REQUIRED_DEVICES:-/dev/uinput /dev/input/event*}
