#!/bin/bash

while getopts "c:v:p:" optname
do
    case "$optname" in
	"c")
	    SUBFILE="$OPTARG"
	    echo "# Chinese subtitles: $AFILE"
	    ;;
	"v")
	    VFILE="$OPTARG"
	    echo "# Video file: $VFILE"
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

if [ "$VFILE" = "" -o "$SUBFILE" = "" -o "$PREFIX" = "" ]; then
    echo "# usage: ./subtitletransformer.sh -v video -c chinese subtitle -p prefix"
    exit 1;
fi

[ ! -e $PREFIX ] && mkdir $PREFIX

function stamp-to-milliseconds () {
     h=$(echo "$1" | sed 's/:.*//g' )
     m=$(echo "$1" | sed 's/[0-9]*://' | sed 's/:.*//g' )
     s=$(echo "$1" | sed 's/[0-9]*:[0-9]*://' | sed 's/,[0-9]*//g' )
    ms=$(echo "$1" | sed 's/[^,]*,//' )
    echo "3600 * $h * 1000 + 60 * $m * 1000 + $s * 1000 + $ms" | bc
}

function snippet-to-part () {
    avconv </dev/null -i $VFILE -y -codec copy -ss $1 -t $2 snippet.$SUFFIX >/dev/null 2>&1
    [ -e audiodump.wav ] && rm audiodump.wav
    avconv </dev/null -i "snippet.$SUFFIX" "audiodump.wav" >/dev/null 2>&1
    normalize-audio -q "audiodump.wav"
    [ -e temp.wav ] && rm temp.wav
    sox --norm=-12 "audiodump.wav" "temp.wav" fade 1.2 reverse
    [ -e faded.wav ] && rm faded.wav
    sox --norm=-12 "temp.wav" "faded.wav" fade 1.2 reverse
    normalize-audio -q "faded.wav"
    [ -e companded.wav ] && rm companded.wav
    sox --norm=-12 "faded.wav" "companded.wav" compand 0.1,0.4 6:-70,-60,-10 -18 -90 0.2
    [ -e normed.wav ] && rm normed.wav
    normalize-audio -q "companded.wav"
    mv "companded.wav" "normed.wav" 
    [ -e "$PREFIX-$STARTMS-$STOPMS.avi" ] && rm "$PREFIX-$STARTMS-$STOPMS.avi"
    VIDEOSTREAM=$(avconv -i snippet.$SUFFIX 2>&1 | grep "Video:" | sed 's|.*Stream #0.\([0-9]\).*|\1|g')
    [ -e "$PREFIX-$STARTMS-$STOPMS.$SUFFIX" ] && rm "$PREFIX-$STARTMS-$STOPMS.$SUFFIX"
    avconv < /dev/null -y -i "snippet.$SUFFIX" -i "normed.wav" -map 0:$VIDEOSTREAM -map 1:0 -acodec libvorbis -vcodec libtheora "$PREFIX-$STARTMS-$STOPMS.ogv" >/dev/null 2>&1
    mv "$PREFIX-$STARTMS-$STOPMS.ogv" "$PREFIX"
}

dos2unix "$SUBFILE"

[ -e import_${PREFIX}.txt ] && rm import_${PREFIX}.txt

FOLDER="videos"
SUFFIX=$(echo "$VFILE" | sed 's/[^.]*.//')
mkdir "$PREFIX"
STOPMS="0"
VIDEOSTOP=$( echo "($STOPMS+1000) * 0.001" | bc -l )

while read LINE; do
    if [ "$SWITCH" = 1 ]; then
	echo "$LINE"
	[ -e snippet.$SUFFIX ] && rm snippet.$SUFFIX
	STARTMS=$(printf %.9d $STARTMS)
	STOPMS=$(printf %.9d $STOPMS)
	if [ "$OLDSTOPMS" -lt "$STARTMS" ]; then
	    # snippet-to-part $OLDVIDEOSTOP $OLDVIDEODURATION
    	    echo -e "\t$OLDSTOPMS-$STARTMS" >> import_${PREFIX}.txt
	    echo "Intermediate: $OLDSTOPMS -> $STARTMS"
	fi
	# snippet-to-part $VIDEOSTART $VIDEODURATION
	VOCABULARY=$(./find_word_definitions.sh -s "$LINE")
    	echo -e "$LINE\t$STARTMS-$STOPMS\t$VOCABULARY" >> import_${PREFIX}.txt
    	SWITCH=0
    fi	
    if [ $( echo "$LINE" | grep -q "[0-90-9]:[0-90-9]"; echo "$?") = 0 ]; then
    	START=$(echo "$LINE" | sed 's/ .*//g')
    	STOP=$(echo "$LINE" | sed 's/.* //g')
	OLDSTOPMS="$STOPMS"
    	STARTMS=$(stamp-to-milliseconds $START)
    	STOPMS=$(stamp-to-milliseconds $STOP)
	echo "$START -> $STARTMS, $STOP -> $STOPMS"
    	VIDEOSTART=$( echo "($STARTMS-1000) * 0.001" | bc -l )
	VIDEOSTART=$( echo $VIDEOSTART | awk '{ if ($1 < 0) print 0; else print $1}') 
	OLDVIDEOSTOP="$VIDEOSTOP"
    	VIDEOSTOP=$( echo "($STOPMS+1000) * 0.001" | bc -l )
	OLDVIDEODURATION=$( echo "$VIDEOSTART - $OLDVIDEOSTOP" | bc -l )
    	VIDEODURATION=$( echo "$VIDEOSTOP - $VIDEOSTART" | bc -l )
    	SWITCH=1
    fi
done < "$SUBFILE"

rm -f snippet.$SUFFIX audiodump.wav temp.wav faded.wav companded.wav normed.wav "$PREFIX-$STARTMS-$STOPMS.avi"





