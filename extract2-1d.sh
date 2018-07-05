#!/bin/bash
#
# Extrat the given variable as function of lat OR lon
# It is asumed that there is a single vertical level and that
# the .nc file contains a single value of iy or jx.
#

if [ $# -ne 3 ]; then
    echo
    echo "Usage:"
    echo "extract2-1d.sh <file>.nc <variable> lat|lon"
    echo
    echo "lat or lon is axis along which the values of the variable run"
    echo
    exit 0
fi

file=$1
variable=$2
axis=$3

if [ ! -f $file ]; then
    echo
    echo "ERROR: file "$file" does not exist."
    echo
    exit 0
fi

if [ "$axis" != "lat" ] && [ "$axis" != "lon" ]; then
    echo
    echo "ERROR: axis has to be lat or lon"
    echo
    exit 0
fi

if [ "$axis" == "lat" ]; then
    ncks -H -C $file -v xlat | rev | cut -d'=' -f 1 | rev | head -n -1 > /tmp/out1
else
    ncks -H -C $file -v xlon | rev | cut -d'=' -f 1 | rev | head -n -1 > /tmp/out1
fi

ncks -H -C -v $variable $file | rev | cut -d'=' -f 1 | rev | head -n -1 > /tmp/out0


paste /tmp/out1 /tmp/out0

rm /tmp/out0 /tmp/out1

