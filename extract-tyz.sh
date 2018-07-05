#!/bin/bash

NPoints=57
Nlevs=18
tcol=1
jx=35
ycol=3
datacol=5
levcol=2

if [ -f /tmp/outvv ]
then
    rm /tmp/outvv
fi

#for i in 01 02 03 04 05 06 07 08 09 10 11 12
for i in 12
do
    ncks -H -C -v ta -d jx,$jx coldfront16_ATM.2016${i}0100.nc | head -n -1 >> /tmp/outvv
done	 

cut -d' ' -f $tcol /tmp/outvv > /tmp/out0
cut -d' ' -f $ycol /tmp/outvv > /tmp/out1
cut -d' ' -f $levcol /tmp/outvv > /tmp/out2
cut -d' ' -f $datacol /tmp/outvv > /tmp/out3

cut -d'=' -f 2 /tmp/out0 > /tmp/outt
cut -d'=' -f 2 /tmp/out1 > /tmp/outy
cut -d'[' -f 2 /tmp/out2 | cut -d']' -f 1  > /tmp/outlev
cut -d'=' -f 2 /tmp/out3 > /tmp/outv

paste /tmp/outt /tmp/outy /tmp/outlev /tmp/outv > /tmp/outv1
#paste /tmp/outt /tmp/outy terraincoord.dat /tmp/outv > /tmp/outv1

((c=0))
((s=0))
ss=$((NPoints*Nlevs))
while read line;
do
    echo $line
    ((c=c+1))
    ((s=s+1))
    
    if (( c == $NPoints ))
    then
	echo
	(( c=0 ))
    fi

    if (( s == $ss ))
    then
	echo
	(( s=0 ))
    fi
   
done < /tmp/outv1


