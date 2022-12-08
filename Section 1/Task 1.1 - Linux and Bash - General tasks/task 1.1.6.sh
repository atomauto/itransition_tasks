#!/bin/bash
#shellcheck disable=SC2102
logfile=$(basename -s .sh "$0").log
echo "Please input only one symbol"
read -r input
if [[ ${#input} -gt 1 ]]; then
    echo "I won't add user input to log, he has typed more than one symbol, maybe he is hacker" > "$logfile"
    echo "You have typed more than one symbol." 
    echo "You are such a dumb user, goodbye!" 
    exit 1
fi
echo "User input is $input" > "$logfile"
case "$input" in
[a-z]) echo "It's lowercase letter" | tee -a "$logfile";;
[A-Z]) echo "It's uppercase letter" | tee -a "$logfile";;
[0-9]) echo "It's digit" | tee -a "$logfile";;
?) echo "It's special character" | tee -a "$logfile";;
*) echo "It's something interesting that I don't know" | tee -a "$logfile" ;;
esac
