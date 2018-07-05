#!/bin/bash
#
# Insert while lines to make it readable with Gnuplot.
# Here we have data that depends on lat lon and time. Two blank lines
# are necessary to separate different blocks of time.
#

if [ $# -ne 2 ]
then
    echo
    echo "Usage:"
    echo "insertWhiteLinesTime.sh <no. of points> <file>"
    echo
    exit 0
fi

NPoints=$1
file=$2


((c=0))
((s=0))
while read line;
do
    echo $line
    ((c=c+1))  
    ((s=s+1))
    
    if (( c == $NPoints ))
    then
	echo
	(( c=0 ))
    fi

    ss=$((NPoints*NPoints))
    if (( s == $ss ))
    then
	echo
	(( s=0 ))
    fi
   
done < $file
