#!/bin/bash
#
# Get latitude and longitude from trmm files
# Longitude goes firts as it is convenient to have it as the x variable
# and longitud as the y variable.
#

if [ $# -ne 1 ]
then
    echo
    echo "Usage:"
    echo "latlon.sh <file to read>.nc"
    echo
    exit 0
fi


file=$1

# get the number of points
njx=$(ncdump -h $file | grep 'longitude' | head -1 | cut -d' ' -f 3)
niy=$(ncdump -h $file | grep 'latitude' | head -1 | cut -d' ' -f 3)

ncks -C -H -v latitude $file | cut -d'=' -f 2 | head -n -1 > /tmp/xlat
ncks -C -H -v longitude $file | cut -d'=' -f 2 | head -n -1 > /tmp/xlon


if [ -f /tmp/latlon ]; then
    rm /tmp/latlon
fi


# make it Gnuplot readable
while read linelat;
do
    while read linelon;
    do
        echo $linelon $linelat >> /tmp/latlon
    done < /tmp/xlon
done < /tmp/xlat



insertWhiteLines.sh $njx /tmp/latlon

rm /tmp/latlon

