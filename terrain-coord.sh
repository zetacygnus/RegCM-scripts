#!/bin/bash
#
# Compute the height in meters corresponding to a given value of sigma for a vertical xz
# or yz section cut.
#
# The output goes to standard output and is organized in columns:
# col 1: latitude or longitude (depending on the vertical cut)
# col 2: sigma
# col 3: p0 pressure at the constant coordinate
# col 4: height in meters


if [ $# -ne 3 ]; then
    echo
    echo "Usage:"
    echo "terrain-coord.sh <file with p0 AND sigma>.nc <cut section: xz|yz> <value of const coordinate index>"
    echo
    echo "Output format:"
    echo "col 1: latitude or longitude (depending on the vertical cut)"
    echo "col 2: sigma"
    echo "col 3: p0 pressure at the constant coordinate"
    echo "col 4: height in meters"
    exit 0
fi


file=$1
plane=$2
cval=$3
nz=$4

if [ ! -f $file ]; then
    echo "ERROR: "$file" does not exist."
    exit 1;
fi

if [ "$plane" == "xz" ]; then
    constCoord=iy
else if [ "$plane" == "yz" ]; then
	 constCoord=jx
     else
	 echo "ERROR: cut section is neither xz or yz."
	 exit 1;
     fi
fi


# Extract pressure from $file
ncks -H -C -d $constCoord,$cval -v p0 $file | rev | cut -d'=' -f 1 | rev | head -n -1 > /tmp/p0temp


# Generated the coordinates
if [ "$constCoord" == "jx" ]; then
    sigmalat.sh $file > /tmp/zhcoord
    np=$(ncdump -h $file | grep 'iy' | head -1 | cut -d' ' -f 3)
else
    sigmalon.sh $file > /tmp/zhcoord
    np=$(ncdump -h $file | grep 'jx' | head -1 | cut -d' ' -f 3)
fi

# Get only the sigma values
cut /tmp/zhcoord -d' ' -f 2 | uniq -d > /tmp/sigmaTemp
nz=$(wc -l /tmp/sigmaTemp | cut -d' ' -f 1)

# Add pressure to the coordinates
if [ -f /tmp/p00 ]; then
    rm /tmp/p00
fi

for(( i=0; i<$nz; i=i+1 ))
do
    cat /tmp/p0temp >> /tmp/p00
done

insertWhiteLines.sh $np /tmp/p00 > /tmp/p00w
paste /tmp/zhcoord /tmp/p00w > /tmp/zhp0



# Compute terrain following coordinate
awk '
  BEGIN{
  OFS="\t"
  R = 287.058  # dry air constant
  T = 300      # temperature
  g = 9.8      # gravity acceleration
  pn = 1.013e5 # pressure at sea level in Pa
  pt = 5000    # pressure of model top in Pa
} 
{
  if ( $1 != "" ){
    print $1,$2,$3,-R*T/g * log( (pt+$2*($3-pt))/pn )
  }
  else{
    print
  }
}' /tmp/zhp0


rm /tmp/{p00,p00w,sigmaTemp,p0temp,zhcoord,zhp0}


exit 0
