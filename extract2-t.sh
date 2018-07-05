#!/bin/bash
#
# Extract a given variable for a fixed z (level). The variable depends only on time.
# If the data does not depend on z, i.e. it is a surface variable, then input -1 as the level.
#


if [ $# -ne 3 ]; then
    echo
    echo "Usage:"
    echo "extract2-t.sh <file>.nc <variable> <level>"
    echo "set <level>  to -1 if the variable has no vertical levels" 
    echo
    exit 0
fi

file=$1
variable=$2
level=$3


if [ ! -f $file ]; then
    echo
    echo "ERROR: file "$file" does not exist."
    echo
    exit 0
fi



if [ -f /tmp/outvv ]; then
    rm /tmp/outvv
fi


# Extract the time coordinate
ncks -H -C -v time $file | cut -d'=' -f 2 | cut -f 1 | head -n -1 > /tmp/time

# Extract the data
if [ $level == -1 ]; then
    ncks -H -C -v $variable $file | rev |cut -d'=' -f 1 | rev | head -n -1 > /tmp/outvv
else    
    ncks -H -C -v $variable -d kz,$level $file | rev |cut -d'=' -f 1 | rev | head -n -1 > /tmp/outvv
fi



# Paste coordinates and data togethere
paste /tmp/time /tmp/outvv





