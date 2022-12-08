#!/bin/bash
logfile=$(basename -s .sh "$0").log
echo "Inputed args:"
while (("$#")); do
    echo $1
    echo $1 >"$logfile"
    shift
done