#!/bin/bash
#
# Get latitude and height.
# Latitude goes firts as it is convenient to have it as the x variable
# and sigma as the y variable.
#

if [ $# -ne 1 ]
then
    echo
    echo "Usage:"
    echo "heilat.sh <file to read>.nc"
    echo
    exit 0
fi


file=$1

if [ -f /tmp/lathei ]; then
    rm /tmp/lathei
fi

# get the number of points
niy=$(ncdump -h $file | grep 'iy' | head -1 | cut -d' ' -f 3)

ncks -C -H -v xlat $file | cut -d'=' -f 4 | head -n -1 | uniq > /tmp/xlat
ncks -C -H -v sigma $file | cut -d'=' -f 2 | head -n -1 > /tmp/hei

# make it Gnuplot readable
while read lineHei;
do
    while read lineLat;
    do
	echo $lineLat $lineHei >> /tmp/lathei
    done < /tmp/xlat
done < /tmp/hei



insertWhiteLines.sh $niy /tmp/lathei


