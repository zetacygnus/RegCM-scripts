#!/bin/bash
#
# Compute the Fourier transform in the command line
#

if [ $# -ne 2 ]
then
    echo
    echo "Usage:"
    echo "fourier.sh <file> <column where data is>"
    echo
    exit 0
fi

datafile=$1
column=$2


npoints=$(wc -l $datafile | cut -d' ' -f 1)

for((i=0; i<npoints; i=i+1))
do
coef=$(awk -v col=$column -v i=$i -v n=$npoints '
BEGIN{ 
  pi=atan2(0,-1);
  ftransR=0.0;
  ftransI=0.0;
}
{
  j=NR-1
  #print j, ftransR, ftransI, pi, i, $col, n, i/n;

  ftransR += $col * cos( -2.0*pi*j*i/n );
  ftransI += $col * sin( -2.0*pi*j*i/n );
}
END{print ftransR/sqrt(n), ftransI/sqrt(n)}' $datafile)

Cre=$(echo $coef | cut -d' ' -f 1)
CIm=$(echo $coef | cut -d' ' -f 2)

echo $Cre $CIm

done


#  for( i=0; i<n; i++ ){
#    ftrans[i] = 0.0;
#    for( j=0; j<n; j++ )
#      ftrans[i] += f[j] * cexp(-2*M_PI*I*j*i/n);
#    
#    ftrans[i] /= sqrt(n);
#  }
