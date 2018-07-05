#!/bin/bash

#rm out*.nc

if [ -f /tmp/pr_raw ]
then
    rm /tmp/pr_raw
fi
   

for i in 01
do
    ncwa -v ta -a iy,jx  gt-test_ATM.1998${i}0100.nc out${i}.nc
    ncks -C -H -v ta out${i}.nc | head -n -1 >> /tmp/pr_raw
done


cut -d' ' -f 1 /tmp/pr_raw | cut -d'=' -f 2 > /tmp/time
cut -d' ' -f 2 /tmp/pr_raw | cut -d'[' -f 2 | cut -d']' -f 1 > /tmp/lev
cut -d' ' -f 3 /tmp/pr_raw | cut -d'=' -f 2 > /tmp/outv

paste /tmp/time /tmp/lev /tmp/outv > /tmp/ta.dat


# average every n lines. Here a line means a 3 hour interval
awk '
BEGIN{n=4; sx=0; sv=0; c=0}
{
  sx=sx+$1;
  sv=sv+$3;
  c=c+1
  if ( c==n ) {
    printf "%f\t%f\t%e\n", sx/n, $2, sv/n;
    c=0; sx=0; sy=0;
  }
}' /tmp/ta.dat > ta.dat
