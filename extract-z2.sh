#!/bin/bash

NPoints=57
xcol=2
ycol=1
datacol=3
#value of height in meters
z=3000
#number of time steps
nt=1440
#number of levels
nlev=18

ncks -H -C -v p0 coldfront16_ATM.2016120100.nc > /tmp/out0

#select the y index
cut -d' ' -f $ycol /tmp/out0 | cut -d'[' -f 2 | cut -d']' -f 1 > /tmp/out1

#select the x index
cut -d' ' -f $xcol /tmp/out0 | cut -d'[' -f 2 | cut -d']' -f 1 > /tmp/out2

#select the value of pressure
cut -d' ' -f $datacol /tmp/out0 | cut -d '=' -f 2 > /tmp/out3

#join the above in a single file
paste /tmp/out2 /tmp/out1 /tmp/out3 | head -n -1 > /tmp/outPressure


awk -v zz=$z '
BEGIN{
  R = 287.058  # dry air constant
  T = 273      # temperature (20 Celcius)
  g = 9.8      # gravity acceleration
  pn = 101325  # pressure at sea level in Pa
  pt = 5000    # pressure of model top in Pa
  # sigma coordinate values
  split( "0.025 0.075 0.13 0.195 0.27 0.35 0.43 0.51 0.59 0.67 0.745 0.8099999 0.865 0.91 0.945 0.97 0.985 0.995", sigma )
} 
{
sz = ( pn*exp(-g*zz/(R*T)) - pt )/( $3 - pt )

for ( i=0; i<length(sigma); i++ ){
  if ( sigma[i] > sz ){
    s1=sigma[i]
    s2=sigma[i-1]
    break
  }
}

print sz FS s1 FS s2 FS i FS i-1
}
' /tmp/outPressure > /tmp/outSigma


paste /tmp/outPressure /tmp/outSigma > /tmp/temp

if [ -f intLevels ]
then
    rm intLevels
fi

for((i=0; i<nt; i=i+1))
do
  cat /tmp/outSigma >> intLevels
done

# Extract all levels to text files
#for((i=1000; i<nlev+1000; i=i+1))
#do
#    lev=$((i-1000))
#    echo "level "$lev
#    ncks -H -C -v ta -d kz,$lev coldfront16_ATM.2016120100.nc | cut -d'=' -f 5 | head -n -1 > /tmp/outLev$i
#done

#echo "Extracting all levels is done"

# Paste all levels in a single file
#if [ -f allLevs ]
#then
#    rm allLevs
#fi

#touch allLevs

#for((i=1000; i<nlev+1000; i=i+1))
#do
#    paste allLevs /tmp/outLev$i >> allLevs1
#    mv allLevs1 allLevs
#done


# Paste all levels with interpolation levels info
paste allLevs intLevels > levsIntLevs




awk -v nn=$nlev '{
  lev1 = $23
  lev2 = $22

  # if the level is inexistent the value is negative
  if ( lev2 > nn ){
    tai = -1
  } 
  else {
    # do linear interpolation
    s =$19
    s2=$20
    s1=$21
    ta1 = $lev1
    ta2 = $lev2

    tai = ta1 + (s-s1) * (ta2-ta1)/(s2-s1)
  }
  
  print tai

}' levsIntLevs > ivalues


# Take out the constat level data and put in its place the interpolated on
cut -f 1,2,3 /tmp/outv1 > /tmp/temp3
paste /tmp/temp3 ivalues > /tmp/temp2



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
   
done < /tmp/temp2


