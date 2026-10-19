#!/bin/sh

# Terminate running bar instances
killall -q polybar

# Wait until the processes have been fully shut down
while pgrep -u "$UID" -x polybar >/dev/null 2>&1; do
    sleep 1
done

find_monitors() {
    echo $(xrandr --query | grep " connected" | eval "$1" | cut -d ' ' -f1)
}

# Launch on all connected monitors
if type "xrandr"; then
    PRIMARY=$(find_monitors "grep primary")
    echo "Primary: $PRIMARY"
    MONITOR="$PRIMARY" polybar --reload main &

    NON_PRIMARY=$(find_monitors "grep -v primary")
    for m in $NON_PRIMARY; do
        MONITOR="$NON_PRIMARY" polybar --reload main &
    done
else
    # Fallback if xrandr isn't available
    polybar --reload main &
fi
