#!/bin/bash

# Average every n lines.
# offset is the number of lines to skip from the beginning.


if [ $# -ne 4 ]; then
    echo
    echo "Usage:"
    echo "averageEveryNLines.sh <file> <no. of lines> <offset> <column>"
    echo
    exit 0
fi

file=$1
nlines=$2
offset=$3
column=$4

awk -v n=$nlines -v off=$offset -v col=$column '
BEGIN{sx=0; sv=0; c=0}
{
  if (NR>off){
    sx=sx+$1;
    sv=sv+$col;
    c=c+1
    if ( c==n ) {
      printf "%f\t%e\n", sx/n, sv/n;
      c=0; sx=0; sv=0;
    }
  }
}' $file

