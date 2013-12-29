#!/bin/bash
cat import.txt | awk -F '\t' '{printf"%s\t%s\n",$1,$6}' | sed 's/\[sound:lola-//g' | sed 's/.mp4\]//g' | sed 's/\([0-9]\)-\([0-9]\)/\1\t\2/g' | sed 's/\t[0]\+/\t/g' | sed 's/\([0-9]\{3\}[^0-9]\)/.\1/g' | sed 's/\([0-9]\{3\}\)$/.\1/g' | awk -F '\t' '{printf("%s\t%i\t%i\n",$1,$2,$3+1)}'
