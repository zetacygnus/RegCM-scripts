#!/bin/bash

#
# Generate labels for contours made with Gnuplot.
#


if [ $# -ne 8 ]
then
    echo
    echo "Usage:"
    echo "contourLabelRot.sh <contour file> <0 or 1> <label width> <label offset> <every> <minimum> <maximum> <font size>"
    echo
    echo "contour file: contour plot generated with Gnuplot"
    echo "0: generate a list with all the labels"
    echo "1: generate the contours with a gap for the label"
    echo "label width: number of contour points to skip in order to leave a gap for the label"
    echo "label offset: where to put the label along the contour, 0 is at the beginning"
    echo "every: label every given number of contours"
    echo "minimum: the minimum label to display"
    echo "maximum: the maximum label to display"
    echo "font size: Gnuplot parameter to use as font size"
    exit 0
fi

# d = 0,1
# w = width
# os = offset
# ev = every
# min = minimum
# max = maximum
# fs = font size

gawk -v d=$2 -v w=$3 -v os=$4 -v ev=$5 -v min=$6 -v max=$7 -v fs=$8  'function abs(x) { return (x>=0?x:-x) }
    BEGIN{cc=0}
    {
            # Column $3 is divided by 1000 to get height in kilometers

            if($0~/# Curve/ && cc%ev==0 ) nr=0; cc++
            if(nr==int(os+w/2)   && d==0 && $3>=min && $3<=max) {a[i]=$1; b[i]=$2; c[i]=$3;}
            if(nr==int(os+w/2)-1 && d==0 && $3>=min && $3<=max) {i++; x = $1; y = $2;}
            if(nr==int(os+w/2)+1 && d==0 && $3>=min && $3<=max) r[i]= 180.0*atan2(y-$2,x-$1)/3.14+180
            if (abs(nr-os-w/2)>w/2 && d==1)
              print $0
            else {
              if ($3>=min && $3<=max && d==1) 
                print "\n"
              else if (d==1) print $0
            }
            

            nr++
    }
    END {   if(d==0) {
                    for(j=1;j<=i;j++)
                    printf "set label %d \"%g\" font \",%d\" at %g, %g centre front rotate by %d\n", j, c[j], fs, a[j], b[j], r[j]
            }
    }' $1
