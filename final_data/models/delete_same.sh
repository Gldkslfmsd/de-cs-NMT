#!/bin/bash

AFIX=1gpu30000
AFIX=model-europarl-1gpu80000
#AFIX=model-europarl-1gpu30000
LS="`ls -t *$AFIX""*.t7 *$AFIX""*Z`"

proc=0
for i in $LS; do
	for j in $LS; do
		if [ "$i" == "$j" ]; then echo $i $j; continue; fi
		{ if diff $i $j >/dev/null 2> /dev/null ; then
			echo $i $j stejný
			echo mažu `ls $i $j -t | head -n 1`
			rm -f `ls $i $j -t | head -n 1`
		fi
		} &
		proc=$(($proc+1))
		if [ $proc -eq 1 ]; then
			echo "čekám"
			wait
			echo "běžim"
			proc=0		
		fi
	done
done
