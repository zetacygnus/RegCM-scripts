#!/bin/bash
#
# Extract a given variable for a fixed z (level). The variable depends on
# time, lat, lon.
# If the data does not depend on z, i.e. it is a surface variable,
# then input -1 as the level.
#


if [ $# -ne 4 ]; then
    echo
    echo "Usage:"
    echo "extract2-txy.sh <file>.nc <variable> <level> <latlon file>"
    echo "set <level>  to -1 if the variable has no vertical levels" 
    echo
    exit 0
fi

file=$1
variable=$2
level=$3
latlonFile=$4

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


if [ -f /tmp/outvv ]; then
    rm /tmp/outvv
fi

# Get number of records (time steps)
Ntime=$(ncks -M $file | grep "Root record dimension" | rev | cut -d'=' -f 1 | rev)

# Extract the data
if [ $level == -1 ]; then
    ncks -H -C -v $variable $file | cut -d'=' -f 5 | head -n -1 > /tmp/outvv
else    
    ncks -H -C -v $variable -d kz,$level $file | cut -d'=' -f 5 | head -n -1 > /tmp/outvv
fi

# Generate lat lon coordinate for each time record
if [ -f /tmp/latlonCoord ]; then
    rm /tmp/latlonCoord
fi

for(( i=0; i<$Ntime; i++ ))
do
    cat $latlonFile >> /tmp/latlonCoord
done

# Paste coordinates and data togethere
paste /tmp/latlonCoord /tmp/outvv





