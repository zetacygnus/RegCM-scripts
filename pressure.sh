#!/bin/bash

# levels go from 1 to 18 (usually)
lev=18

# Compute terrain following coordinate
if [ -f pstat2.dat ]
then
    rm pstat2.dat
fi

head -n -1 /tmp/outTopo1 > /tmp/outTopo22

awk -v zl=$lev '
BEGIN{
  # pressure of model top in Pa
  pt = 5000
  # sigma coordinate values
  split( "0.025 0.075 0.13 0.195 0.27 0.35 0.43 0.51 0.59 0.67 0.745 0.8099999 0.865 0.91 0.945 0.97 0.985 0.995", sigma )
} 
{
  print pt+sigma[zl]*($3-pt) 
}' /tmp/outTopo22 > pstat.dat



# Repeat the coordinates for every time step
ntimesteps=1440
for((i=0; i<$ntimesteps; i=i+1))
do
    cat pstat.dat >> pstat2.dat
done
