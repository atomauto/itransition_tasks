#!/bin/bash
logfile=$(basename -s .sh "$0").log
#Considering running script with root privilegies
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with root privilegies"
    echo "Unsuccesful script run (not enough rights)" > "$logfile"
    exit 1
fi