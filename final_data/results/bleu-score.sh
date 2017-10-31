#!/bin/bash
mkdir -p tmp
python3 bleu-sort.py $1 $2 > both
for i in `seq 0 99`; do
	RES=`perl multi-bleu.perl tmp/$1"".$i < tmp/$2"".$i 2> /dev/null`
	echo -n $RES | sed 's/,//' | awk '{ print $3 }' | tr '\n' ' '
	echo -n " "
	echo $RES
done > bleus
paste bleus both | sort -n -k 1 -r
