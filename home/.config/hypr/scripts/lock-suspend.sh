#!/usr/bin/env bash
# Lock + display-off + suspend (lid also suspends via logind; harmless duplicate).
set -uo pipefail

noctalia msg session lock
sleep 1 # let lock engage or resume flashes unlocked desktop
hyprctl dispatch dpms off
systemctl suspend
