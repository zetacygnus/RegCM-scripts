#!/bin/bash
#
# Insert while lines to make it readable with Gnuplot
#

if [ $# -ne 2 ]
then
    echo
    echo "Usage:"
    echo "insertWhiteLines.sh <no. of points> <file>"
    echo
    exit 0
fi

if [ -f /tmp/tmpIns ]
then
   rm /tmp/tmpIns
fi

NPoints=$1
file=$2

((c=0))
while read line;
do
    echo $line >> /tmp/tmpIns
    ((c=c+1))

    if (( c == $NPoints ))
    then
	echo >> /tmp/tmpIns
	(( c=0 ))
    fi
done < $file


# Take out tha last line that is an empty line
head -n -1 /tmp/tmpIns

