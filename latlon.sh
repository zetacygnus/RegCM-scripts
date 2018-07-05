#!/bin/bash
#
# Get latitude and longitude.
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
njx=$(ncdump -h $file | grep 'jx' | head -1 | cut -d' ' -f 3)
niy=$(ncdump -h $file | grep 'iy' | head -1 | cut -d' ' -f 3)

ncks -C -H -v xlat $file | cut -d'=' -f 4 | head -n -1 > /tmp/xlat
ncks -C -H -v xlon $file | cut -d'=' -f 4 | head -n -1 > /tmp/xlon


paste /tmp/xlon /tmp/xlat > /tmp/latlon

insertWhiteLines.sh $njx /tmp/latlon


