#!/bin/bash
logfile=$(basename -s .sh "$0").log
echo "Script simulates 700 dice rolls"
ones=twos=threes=fours=fives=sixes=0
for i in {1..700}; do
    dice=$(($RANDOM % 6 + 1))
    case $dice in
    1) ((ones++)) ;;
    2) ((twos++)) ;;
    3) ((threes++)) ;;
    4) ((fours++)) ;;
    5) ((fives++)) ;;
    6) ((sixes++)) ;;
    esac
done
echo "единиц   =   $ones" | tee -a "$logfile"
echo "двоек    =   $twos" | tee -a "$logfile"
echo "троек    =   $threes" | tee -a "$logfile"
echo "четверок =   $fours" | tee -a "$logfile"
echo "пятерок  =   $fives" | tee -a "$logfile"
echo "шестерок =   $sixes" | tee -a "$logfile"