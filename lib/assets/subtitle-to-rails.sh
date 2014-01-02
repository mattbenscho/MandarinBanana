#!/bin/bash

while getopts "c:p:" optname
do
    case "$optname" in
	"c")
	    AFILE="$OPTARG"
	    echo "# Chinese subtitles: $AFILE"
	    ;;
	"p")
	    PREFIX="$OPTARG"
	    echo "# Prefix: $PREFIX"
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

USAGE="# usage: ./subtitletransformer.sh -p prefix -c chinese subtitle"

if [ "$AFILE" = "" -o "$PREFIX" = "" ]; then
    echo "$USAGE"
    exit 1;
fi

function stamp-to-seconds () {
     h=$(echo "$1" | sed 's/:.*//g' )
     m=$(echo "$1" | sed 's/[0-9]*://' | sed 's/:.*//g' )
     s=$(echo "$1" | sed 's/[0-9]*:[0-9]*://' | sed 's/,[0-9]*//g' )
    ms=$(echo "$1" | sed 's/[^,]*,//' )
    echo "( 3600 * $h * 1000 + 60 * $m * 1000 + $s * 1000 + $ms + $2 ) / 1000" | bc
}

dos2unix "$AFILE"

[ -e import_$PREFIX.txt ] && rm import_$PREFIX.txt

while read ALINE; do
    if [ "$SWITCH" = 1 ]; then
    	ASENTENCE="$ALINE"
	echo "$ASENTENCE"
	ASTARTS=$(printf %d $ASTARTS)
	ASTOPS=$(printf %d $ASTOPS)
    	echo -e "$ALINE\t$ASTARTS\t$ASTOPS" >> import_$PREFIX.txt
    	SWITCH=0
    fi	
    if [ $( echo "$ALINE" | grep -q "[0-90-9]:[0-90-9]"; echo "$?") = 0 ]; then
    	ASTART=$(echo "$ALINE" | sed 's/ .*//g')
    	ASTOP=$(echo "$ALINE" | sed 's/.* //g')
    	ASTARTS=$(stamp-to-seconds $ASTART 0)
    	ASTOPS=$(stamp-to-seconds $ASTOP 1000)
	echo "$ASTART -> $ASTARTS, $ASTOP -> $ASTOPS"
    	SWITCH=1
    fi
done < "$AFILE"

