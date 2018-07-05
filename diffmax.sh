#!/bin/bash
#
# Compute the difference in time between the two maximum values of the
# time series.
# Input should be precipitation as function of space and time for one
# year (and maybe averaged every two weeks).
#

if [ $# -ne 2 ]
then
    echo
    echo "Usage:"
    echo "diffmax.sh <file.nc> <latlonfile>"
    echo
    exit 0
fi


dataFile=$1
latlonFile=$2

if [ ! -f $dataFile ]; then
    echo
    echo "ERROR: File "$dataFile " does not exist"
    echo
    exit 0
fi

outdata="tempdiffmax"

if [ -f $outdata  ]; then
    rm $outdata
fi

# get the number of points
njx=$(ncdump -h $dataFile | grep 'jx' | head -1 | cut -d' ' -f 3)
niy=$(ncdump -h $dataFile | grep 'iy' | head -1 | cut -d' ' -f 3)


for(( i=0; i<niy; i=i+1 ))
do
    for(( j=0; j<njx; j=j+1 ))
    do
       # get the column with the data
	ncks -H -C -d jx,$j -d iy,$i -v pr $dataFile | tr '=' ' ' | cut -d' ' -f 2,8 > temp

	# sort data in descending order
	sort -r -g -k 2 temp > temp1

	v1=$(awk '{ if (NR==1) print $1 }' temp1)
	v2=$(awk '{ if (NR==2) print $1 }' temp1)

	dv=$(echo $v1-$v2 | bc )

	echo $dv >> $outdata

    done  
done



paste $latlonFile $outdata

rm temp temp1 $outdata


