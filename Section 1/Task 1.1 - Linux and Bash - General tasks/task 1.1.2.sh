#!/bin/bash
logfile=$(basename -s .sh "$0").log
echo "Type something, I'm waiting..."
read -r text
echo "$text"
echo "Tss, user input is " > "$logfile"
echo "$text" >> "$logfile"
echo "Remember, Big Brother is watching!" >> "$logfile"