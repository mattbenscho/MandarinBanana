#!/bin/bash

while read LINE; do
    G1=$(echo "$LINE" | awk -F '\t' '{print $1}')
    G2=$(echo "$LINE" | awk -F '\t' '{print $2}')
    echo "$G1"
    echo "$G2"
done < gorodish-pinyin-key.csv