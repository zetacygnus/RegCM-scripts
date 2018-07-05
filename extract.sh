#!/bin/bash

NPoints=47
xcol=2
ycol=1
datacol=3

ncks -H -C -v topo gt-test_ATM.1998010100.nc > /tmp/out0

cut -d' ' -f $ycol /tmp/out0 > /tmp/out1
cut -d' ' -f $xcol /tmp/out0 > /tmp/out2
cut -d' ' -f $datacol /tmp/out0 > /tmp/out3

cut -d'=' -f 2 /tmp/out1 > /tmp/outy
cut -d'=' -f 2 /tmp/out2 > /tmp/outx
cut -d'=' -f 2 /tmp/out3 > /tmp/outTopo

paste /tmp/outx /tmp/outy /tmp/outTopo > /tmp/outTopo1

((c=0))
while read line;
do
    echo $line
    ((c=c+1))

    if (( c == $NPoints ))
    then
	echo
	(( c=0 ))
    fi
   
done < /tmp/outTopo1
