#!/bin/bash

# Check if an argument (left or right) is provided
if [ $# -eq 0 ]; then
    echo "Error: Please specify 'left' or 'right' as an argument."
    exit 1
fi

# Get the argument
position="$1"

# Check if the argument is 'left' or 'right'

if [ "$position" == "left" ]; then
    xrandr --output HDMI-1-0 --auto --left-of eDP-1
    bspc monitor HDMI-1-0 -d I II III IV V
    bspc monitor eDP-1 -d VI VII VIII IX X
elif [ "$position" == "right" ]; then
    xrandr --output HDMI-1-0 --auto --right-of eDP-1
    bspc monitor HDMI-1-0 -d VI VII VIII IX X
    bspc monitor eDP-1 -d I II III IV V
else
    echo "Error: Please specify 'left' or 'right' as an argument."
    exit 1
fi

# Terminate already running bar instances
killall -q polybar

## Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch on all monitors
if [ -z $(which xrandr) ]; then
    echo "xrandr not found"
    exit 1
else
    echo "xrandr found"
    ORDER=0
    for monitor in $(xrandr -q | grep ' connected' | awk '{print $1}'); do
        ORDER=$((ORDER + 1))
        MONITOR=$monitor /home/romanshkvolkov/.config/polybar/launch.sh &
    done
fi
