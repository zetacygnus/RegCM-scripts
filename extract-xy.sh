#!/bin/bash
#
# Extrat the given variable as function of lat and lon.
# It is asumed that there is a single vertical level.
#

if [ $# -ne  ]; then
    echo
    echo "Usage:"
    echo "extract2-txy.sh <file>.nc <variable> <lat lon file>"
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

ncks -H -C -v $variable $file | cut -d'=' -f 4 | head -n -1 > /tmp/out0
paste $latlonFile /tmp/out0

