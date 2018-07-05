#!/bin/bash
#
# Extrat the given variable as function of height (z) and lat (y).
# It is asumed that there is a single value of longitud coordinate
#

if [ $# -ne 3 ]; then
    echo
    echo "Usage:"
    echo "extract2-yz.sh <file>.nc <variable> <longitud height file>"
    echo
    exit 0
fi

file=$1
variable=$2
lonheiFile=$3

if [ ! -f $file ]; then
    echo
    echo "ERROR: file "$file" does not exist."
    echo
    exit 0
fi

if [ ! -f $lonheiFile ]; then
    echo
    echo "ERROR: file "$latlonFile" does not exist."
    echo
    exit 0
fi

# get the number of points
niy=$(ncdump -h $file | grep 'iy' | head -1 | cut -d' ' -f 3 )

ncks -H -C -v $variable $file | rev | cut -d'=' -f 1 | rev | head -n -1 > /tmp/out0

insertWhiteLines.sh $niy /tmp/out0 > /tmp/out1

paste $lonheiFile /tmp/out1

rm /tmp/out0 /tmp/out1

