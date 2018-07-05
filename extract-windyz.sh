#!/bin/bash

NPoints=27
Nlevs=18
tcol=1
jx=13
ycol=3
datacol=5
levcol=2

if [ -f /tmp/outUa ]
then
    rm /tmp/outUa /tmp/outWa
fi


for i in 01 02 03 04 05 06 07 08 09 10 11 12
#for i in 01
do
    ncks -H -C -v ua -d jx,$jx coldfront_ATM.1998${i}0100.nc | head -n -1 >> /tmp/outUa
    ncks -H -C -v wa -d jx,$jx coldfront_ATM.1998${i}0100.nc | head -n -1 >> /tmp/outWa
done

cut -d' ' -f $tcol /tmp/outUa > /tmp/out0
cut -d' ' -f $ycol /tmp/outUa > /tmp/out1
cut -d' ' -f $levcol /tmp/outUa > /tmp/out2
cut -d' ' -f $datacol /tmp/outUa > /tmp/out3
cut -d' ' -f $datacol /tmp/outWa > /tmp/out4

cut -d'=' -f 2 /tmp/out0 > /tmp/outt
cut -d'=' -f 2 /tmp/out1 > /tmp/outy
cut -d'[' -f 2 /tmp/out2 | cut -d']' -f 1 > /tmp/outlev
cut -d'=' -f 2 /tmp/out3 > /tmp/outU
cut -d'=' -f 2 /tmp/out4 > /tmp/outW

#paste /tmp/outt /tmp/outy /tmp/outlev /tmp/outU /tmp/outW > /tmp/outUW
paste /tmp/outt /tmp/outy terraincoord.dat /tmp/outU /tmp/outW > /tmp/outUW

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
   
done < /tmp/outUW
