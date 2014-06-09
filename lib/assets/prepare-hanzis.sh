#!/bin/bash

touch prepared-hanzis.csv

while read -n1 char; do
    if [ $(cat prepared-hanzis.csv | grep -q "^$char"; echo "$?") = "1" ]; then
	if [ $(grep -q "^. $char " cedict.csv; echo "$?") = "1" ];
	then	    
	    COMPOSITION=$(./decompose.sh $char | tr -d '\n')
	    echo -e "$char\t\t\t\t\t$COMPOSITION"
	    echo -e "$char\t\t\t\t\t$COMPOSITION" >> prepared-hanzis.csv
	else
	    while read LINE; do 
		TCHAR=$(echo "$LINE" | awk -F '\t' '{print $1}')
		SCHAR=$(echo "$LINE" | awk -F '\t' '{print $2}')
		PINYIN=$(echo "$LINE" | awk -F '\t' '{print $3}' | tr -d '[]' | tr [A-Z] [a-z])
		TRANSLATION=$(echo "$LINE" | awk -F '\t' '{print $4}' | sed 's|^/||' | sed 's|/$||' | sed 's|/| / |g')
		G1=$(grep "	$PINYIN\$" gorodish-pinyin-key.csv | awk -F '\t' '{print $1}')
		G2=$(grep "	$PINYIN\$" gorodish-pinyin-key.csv | awk -F '\t' '{print $2}')
		SCOMPOSITION=$(./decompose.sh $SCHAR | tr -d '\n')
		TCOMPOSITION=$(./decompose.sh $TCHAR | tr -d '\n')
		OUT1="$TCHAR\t$PINYIN\t$TRANSLATION\t$G1\t$G2\t$TCOMPOSITION"
		OUT2="$SCHAR\t$PINYIN\t$TRANSLATION\t$G1\t$G2\t$SCOMPOSITION"
		echo -e "$OUT1\n$OUT2" | uniq
		echo -e "$OUT1\n$OUT2" | uniq >> prepared-hanzis.csv
		./prepare-hanzis.sh "$SCOMPOSITION$TCOMPOSITION"
	    done < <(grep "^. $char " cedict.csv | sed 's/ /\t/' | sed 's/ /\t/' | sed 's/ /\t/')
	fi
    fi
done < <(echo "$1")