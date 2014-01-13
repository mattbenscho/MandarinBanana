#!/bin/bash

while read -n 1 char; do
    while read LINE; do 
	TCHAR=$(echo "$LINE" | awk -F '\t' '{print $1}')
	SCHAR=$(echo "$LINE" | awk -F '\t' '{print $2}')
	PINYIN=$(echo "$LINE" | awk -F '\t' '{print $3}' | tr -d '[]' | tr [A-Z] [a-z])
	TRANSLATION=$(echo "$LINE" | awk -F '\t' '{print $4}' | sed 's|^/||' | sed 's|/$||' | sed 's|/| / |g')
	G1=$(grep "	$PINYIN\$" gorodish-pinyin-key.csv | awk -F '\t' '{print $1}')
	G2=$(grep "	$PINYIN\$" gorodish-pinyin-key.csv | awk -F '\t' '{print $2}')
        echo -e "$TCHAR\t$PINYIN\t$TRANSLATION\t$G1\t$G2"
        echo -e "$SCHAR\t$PINYIN\t$TRANSLATION\t$G1\t$G2"
    done < <(grep "^. $char " "../assets/cedict.csv" | sed 's/ /\t/' | sed 's/ /\t/' | sed 's/ /\t/')
done < <(echo "$1")