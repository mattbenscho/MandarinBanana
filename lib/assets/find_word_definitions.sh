#!/bin/bash

# Usage example: ./find_word_definitions.sh -s "我说中文"

# Output: Translation vor every character and compound word.

while getopts "s:" optname; do
    case "$optname" in
	"s")
	    SENTENCE=$(echo "$OPTARG" | tr -d '[]')
	    ;;
	"?")
	    echo "# Unknown option $OPTARG"
	    ;;
	":")
	    echo "# No argument value for option $OPTARG"
	    ;;
	*)
	    echo "# Unknown error while processing options"
	    ;;
    esac
done

function fetch-dictline {
    DEF=""
    M="$L"
    DEF=$(grep "^$WORD	" cedict_uniq.csv | sed 's/"/\\\\"/g' | awk -F '\t' '{printf "\"%s\"", $2}' | sed "s|// $WORD |// |g" | sed "s| // |\", \"|g")
    if [ "${DEF}x" != "x" ]; then
	if [ "${VOCABULARY}" = "[" ]; then
	    VOCABULARY="[[\"$WORD\", [$DEF]]"
	else
	    VOCABULARY="$VOCABULARY, [\"$WORD\", [$DEF]]"
	fi
	# echo -e "[$WORD, [$DEF]]"
	I=$(( I + L ))
	continue
    fi
    if [ "$L" = "1" -a "${DEF}x" = "x" ]; then
	I=$(( I + L ))
	continue
    fi
}

VOCABULARY="["
CHARACTER=( $(while read -n 1 CHARVAR; do echo "$CHARVAR"; done < <(echo "$SENTENCE" | sed 's/[…“”0-9a-zA-Z\.!?！？,，。-]*/ /g')) )
#echo "${CHARACTER[@]}"

############################# Compound words #################################
I=0
N=$(( ${#CHARACTER[@]}-1 ))
while ( [ $I -le $N ] ); do
    # echo "$I ${CHARACTER[I]}"
    if [ "$I" -le "$(($N-3))" ]; then # Wenn I <= N-3
	L=4
	WORD="${CHARACTER[I]}${CHARACTER[I+1]}${CHARACTER[I+2]}${CHARACTER[I+3]}"; fetch-dictline
    fi
    if [ "$I" -le "$(($N-2))" ]; then # Wenn I <= N-2
	L=3
	WORD="${CHARACTER[I]}${CHARACTER[I+1]}${CHARACTER[I+2]}"; fetch-dictline
    fi
    if [ "$I" -le "$(($N-1))" ]; then # Wenn I <= N-1
	L=2
	WORD="${CHARACTER[I]}${CHARACTER[I+1]}"; fetch-dictline
    fi
    L=1
    WORD="${CHARACTER[I]}"; fetch-dictline
done

#############################################################################

if [ "${VOCABULARY}" != "\[" ]; then
    VOCABULARY="$VOCABULARY, [\"----------\", [\"Definitions for words above consisting of more than one character:\"]]"
fi

############################### single words ################################

I=0
N=$(( ${#CHARACTER[@]}-1 ))
while ( [ $I -le $N ] ); do
    #echo "$I ${CHARACTER[I]}"
    L=4
    WORD="${CHARACTER[I]}"
    DEF=""
    M="1"
    # DEF=$(grep "^$WORD	" cedict_uniq.csv | awk -F '\t' '{print $2}' | sed "s|// $WORD |// |g" | sed "s|//|\n|g")
    DEF=$(grep "^$WORD	" cedict_uniq.csv | sed 's/"/\\\\"/g' | awk -F '\t' '{printf "\"%s\"", $2}' | sed "s|// $WORD |// |g" | sed "s| // |\", \"|g")
    #echo "$DEF"
    if [ "${DEF}x" != "x" ]; then
	if [ "${VOCABULARY}" = "\[" ]; then
	    VOCABULARY="[[\"$WORD\", [$DEF]]"
	else
	    if [ $(echo "$VOCABULARY" | grep -q -F "[\"$WORD\", [$DEF]]"; echo "$?") != 0 ]; then
		VOCABULARY="$VOCABULARY, [\"$WORD\", [$DEF]]"
		# echo -e "[$WORD, [$DEF]]"
	    fi
	fi
	I=$(( I + 1 ))
	continue
    fi
    if [ "${DEF}x" = "x" ]; then
	I=$(( I + L ))
	continue
    fi
done

# echo "##########################################################"

if [ "${VOCABULARY}" = "\[" ]; then
    VOCABULARY="[]"
else
    VOCABULARY="$VOCABULARY]"
fi

echo "$VOCABULARY"

exit 0
