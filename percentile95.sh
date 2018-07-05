#!/bin/bash
#
# Column 1: longitude
#
# Column 2: latitude
#
# Column 3: Compute de 95 percentile from a distribution in space and time
# The output is a 2D map with the value of the 95 percentile of every
# grid point. The percentile is computed taking into account only rainy
# days (precipitation greater or equal de 1 mm/day).
#
# Column 4: Total amount of precipitation
#
# Column 5: Precipicitation due to events from P95 and higher
#

if [ $# -ne 2 ]
then
    echo
    echo "Usage:"
    echo "perceintile95.sh <file>.nc <lon lat coordinates file>"
    echo
    exit 0
fi


dataFile=$1
latlonFile=$2

if [ ! -f $latlonFile ]; then
    echo
    echo "ERROR: File "$latlonFile " does not exist"
    echo
    exit 0
fi

if [ ! -f $dataFile ]; then
    echo
    echo "ERROR: File "$dataFile " does not exist"
    echo
    exit 0
fi

outdata="temp95"

if [ -f $outdata  ]; then
    rm $outdata
fi


# get the number of points
njx=$(ncdump -h $dataFile | grep 'jx' | head -1 | cut -d' ' -f 3)
niy=$(ncdump -h $dataFile | grep 'iy' | head -1 | cut -d' ' -f 3)


for(( i=0; i<niy; i=i+1 ))
do
    echo $i"/"$niy 1>&2
    for(( j=0; j<njx; j=j+1 ))
    do
       # get the column with the data
	ncks -H -C -d jx,$j -d iy,$i -v pr $dataFile | tr '=' ' ' | cut -d' ' -f 8 > temp
	
	# get only days with pr >= 1 mm/day
	awk '{ if ($1*24.*3600.>=1.0) print $1 }' temp | sort -g > temp1
	
	# get the number of lines
	nl=$(wc -l temp1 | cut -d' ' -f 1)
	
	# compute percentile 95 record (line) number
	rn=$(echo 0.95*$nl | bc)
	rn=$(printf "%.0f" $rn )
	
	# get the required record
	p95=$(awk -v nn=$rn '{ if (NR==nn) print $1}' temp1)

	# compute total amount of precipitation
	prt=$(awk 'BEGIN{s=0}{s=s+$1}END{print s}' temp1)

	# compute precipitation for event equal and above P95
	tail -n +$rn temp1 > temp2
	pa95=$(awk 'BEGIN{s=0}{s=s+$1}END{print s}' temp2)
	
	echo -e $p95"\t"$prt"\t"$pa95 >> $outdata
    done  
done

insertWhiteLines.sh $njx $outdata > temp951

paste $latlonFile temp951



rm temp temp1 temp2 $outdata temp951
      
    
