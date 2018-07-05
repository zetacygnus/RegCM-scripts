#!/bin/bash
#
# Get the terrain elevation as a function of latitud and longitud coordinates.
#

if [ $# -ne 2 ]
then
    echo
    echo "Usage:"
    echo "extract2-topo.sh <file>.nc <lon lat coordinates file>"
    echo
    exit 0
fi

topoFile=$1
latlonFile=$2

if [ ! -f $latlonFile ]; then
    echo
    echo "ERROR: File "$latlonFile " does not exist"
    echo
    exit 0
fi

if [ ! -f $topoFile ]; then
    echo
    echo "ERROR: File "$topoFile " does not exist"
    echo
    exit 0
fi

# get the number of points
njx=$(ncdump -h $topoFile | grep 'jx' | head -1 | cut -d' ' -f 3)
niy=$(ncdump -h $topoFile | grep 'iy' | head -1 | cut -d' ' -f 3)


# get elevation
ncks -H -C -v topo $topoFile | cut -d'=' -f 4 | head -n -1  > /tmp/out0

insertWhiteLines.sh $njx /tmp/out0 > /tmp/out1

# merge with lat lon coordinates
paste $latlonFile /tmp/out1

rm /tmp/out0 /tmp/out1


