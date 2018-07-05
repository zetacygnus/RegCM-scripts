#!/bin/bash
#
# Get longitude and height.
# Longitude goes first as it is convenient to have it as the x variable
# and sigma as the y variable.
#

if [ $# -ne 1 ]
then
    echo
    echo "Usage:"
    echo "heilon.sh <file to read>.nc"
    echo
    exit 0
fi


file=$1

if [ -f /tmp/lonhei ]; then
    rm /tmp/lonhei
fi

# get the number of points
njx=$(ncdump -h $file | grep 'jx' | head -1 | cut -d' ' -f 3)

ncks -C -H -v xlon  $file | cut -d'=' -f 4 | head -n $njx > /tmp/xlon
ncks -C -H -v sigma $file | cut -d'=' -f 2 | head -n -1 > /tmp/hei

# make it Gnuplot readable
while read lineHei;
do
    while read lineLon;
    do
	echo $lineLon $lineHei >> /tmp/lonhei
    done < /tmp/xlon   
done < /tmp/hei



insertWhiteLines.sh $njx /tmp/lonhei


