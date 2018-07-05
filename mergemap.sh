#!/bin/bash

convert -resize 49.737% /home/enrique/research/maps/guatemala20-1.png gt.png

((c=1000))

for i in pics/*png
do
    composite -geometry +217+157 gt.png $i  pics-map/frame-$c.png
    echo $i
    ((c=c+1))
done
