#!/bin/bash
logfile=$(basename -s .sh "$0").log
echo "Script converts meters to miles"
echo "Please input meters, decimal values aren't supported yet"
read -r meters
if [[ "$meters" -ge 0 ]]; then
    # Bash cannot in floating point itself
    # miles=$(($meters / 1609))
    # So we have to use bc and many brackets :(
    miles=$(bc -l <<<"$meters/1609")
    echo "This is $miles miles"
    echo "Converted $meters meters to $miles miles" >"$logfile"
else
    echo "You have typed something wrong. Maybe, you shouldn't eat hamburger and use keyboard at the same time?" | tee -a "$logfile"
    exit 1
fi
echo "We suggest switching US to metric system rather than use convertion scripts"
