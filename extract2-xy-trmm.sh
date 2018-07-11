#!/bin/bash
#
# Extrat the given variable as function of lat and lon from TRMM files.
# It is asumed that there is a single vertical level.
#

if [ $# -ne 3 ]; then
    echo
    echo "Usage:"
    echo "extract2-xy-trmm.sh <file>.nc <variable> <lat lon file>"
    echo
    exit 0
fi

file=$1
variable=$2
latlonFile=$3

if [ ! -f $file ]; then
    echo
    echo "ERROR: file "$file" does not exist."
    echo
    exit 0
fi

if [ ! -f $latlonFile ]; then
    echo
    echo "ERROR: file "$latlonFile" does not exist."
    echo
    exit 0
fi

# get the number of points
njx=$(ncdump -h $file | grep 'longitude' | head -1 | cut -d' ' -f 3)

ncks -H -C -v $variable $file | rev | cut -d'=' -f 1 | rev | head -n -1 > .out0

insertWhiteLines.sh $njx .out0 > .out1

paste $latlonFile .out1

rm .out0 .out1

