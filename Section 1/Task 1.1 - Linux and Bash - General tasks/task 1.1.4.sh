#!/bin/bash
logfile=$(basename -s .sh "$0").log
date +%s
date +%s > "$logfile"
echo "What do you think about year 2038 problem?"