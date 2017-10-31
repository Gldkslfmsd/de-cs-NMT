#!/bin/bash
EVAL=multi-bleu.perl

if [ -z "$1" ]; then
	TEST=test
	RES=""
else
	echo dev
	TEST=dev
	RES=dev
fi

for i in *.t7 *Z; do
	if [ ! -f $i"".cs.$RES""pred.post ]; then continue; fi
	if [ ! -f $i"".cs.$RES""pred.post.res ]; then
		RESULT=`perl $EVAL /net/work/people/machacek/opennmt-experiments/de-cs-NMT/final_data/$TEST"".cs.post < $i"".cs.$RES""pred.post 2>/dev/null`
		echo $RESULT > $i"".cs.pred.post.$RES""res
	else
		RESULT=`cat $i"".cs.$RES""pred.post.res`
	fi
	echo `ls -l $i --time-style="+%Y-%m-%d_%H:%M:%S" | awk '{print $6 " " $7}'`  "$RESULT"
done

