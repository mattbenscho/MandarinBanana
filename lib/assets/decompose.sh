#!/bin/bash

# Decompose a Chinese character and return its parts, one part per line

CHARACTER="$1"
PART1=""
PART2=""
RADICAL=""
DECOMPLINE=$(grep "^	$CHARACTER	" composition-table_2014-05-29_raw.csv)
PART1=$(echo "$DECOMPLINE" | awk -F '\t' '{print $5}' | sed 's/?//g' | tr -d '*?')
PART2=$(echo "$DECOMPLINE" | awk -F '\t' '{print $8}' | sed 's/?//g' | tr -d '*?')
DECOMP="$PART1$PART2$RADICAL"
if [ "${DECOMP}x" != "x" ]; then
    DECOMP=$(while read -n 1 CHAR; do echo "$CHAR"; done < <(echo -e "$PART1\n$PART2" | sed 's/[0-9a-zA-Z]//g' ) | sort -u | sed "s|$CHARACTER||g")
fi

echo "$DECOMP" | sed '/^$/d'

exit 0