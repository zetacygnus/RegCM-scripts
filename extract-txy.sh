#!/bin/bash

NPoints=117
tcol=1
xcol=4
ycol=3
datacol=5
level=17

if [ -f /tmp/outvv ]
then
    rm /tmp/outvv
fi

#for i in 01 02 03 04 05 06 07 08 09 10 11 12
for i in *ATM.201612*
do
    ncks -H -C -v ta -d kz,$level ${i} | head -n -1 >> /tmp/outvv
done

cut -d' ' -f $tcol /tmp/outvv > /tmp/out0
cut -d' ' -f $ycol /tmp/outvv > /tmp/out1
cut -d' ' -f $xcol /tmp/outvv > /tmp/out2
cut -d' ' -f $datacol /tmp/outvv > /tmp/out3

cut -d'=' -f 2 /tmp/out0 > /tmp/outt
cut -d'=' -f 2 /tmp/out1 > /tmp/outy
cut -d'=' -f 2 /tmp/out2 > /tmp/outx
cut -d'=' -f 2 /tmp/out3 > /tmp/outv

paste /tmp/outt /tmp/outx /tmp/outy /tmp/outv > /tmp/outv1

((c=0))
((s=0))
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

    ss=$((NPoints*NPoints))
    if (( s == $ss ))
    then
	echo
	(( s=0 ))
    fi
   
done < /tmp/outv1


rm /tmp/outt /tmp/outx /tmp/outy /tmp/outv /tmp/outv1
