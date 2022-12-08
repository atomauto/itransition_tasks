#!/bin/bash
logfile=$(basename -s .sh "$0").log
echo "Type something, I'm waiting..."
echo "I'm tired today, you have only 5 seconds"
if read -r -t 5 text;
then echo "So quick?"
else echo "You cannot even type anything in 5 sec??? Really?"
fi
echo "$text"
echo "Tss, user input is " > "$logfile"
echo "$text" >> "$logfile"
echo "Remember, Big Brother is watching!" >> "$logfile"