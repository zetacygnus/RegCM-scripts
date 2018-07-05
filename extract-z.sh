#!/bin/bash

NPoints=57
xcol=2
ycol=1
datacol=3
#value of height in meters
z=1500
#number of time steps
nt=1439
#number of leves
nlev=18

ncks -H -C -v p0 coldfront16-4_ATM.2016120100.nc > /tmp/out0

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

exit 0

awk -v nn=$nlev '{
  if ( ($7 < nn) && ($8 < nn) ){
    cmd="ncks -H -C -v ta -d time,0 -d jx,"$1" -d iy,"$2" -d kz,"$7" coldfront16_ATM.2016120100.nc | cut -d'=' -f 5"
    cmd | getline ta2
    close(cmd)

    cmd="ncks -H -C -v ta -d time,0 -d jx,"$1" -d iy,"$2" -d kz,"$8" coldfront16_ATM.2016120100.nc | cut -d'=' -f 5"
    cmd | getline ta1
    close(cmd)
} 

# do linear interpolation
  s=$4
  s2=$5
  s1=$6

  tai = ta1 + (s-s1) * (ta2-ta1)/(s2-s1)
  
  print tai

}' /tmp/temp





exit 1


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
   
done < /tmp/temp
