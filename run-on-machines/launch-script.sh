#!/bin/bash
# < params

par=$PWD/$1
cd OpenNMT
i=1
HOST=`hostname`
	echo tady $par
	cat $par
: > $par"".finished
while [ -s "$par" ]; do
	cat $par
	echo tady $par
	CMD=`head -n 1 "$par"`
	tmp=`mktemp`
	tail -n +2 "$par" > $tmp
	mv $tmp "$par"
	echo $CMD > $par"".running

	echo $CMD #-log_file $HOME/$HOST""-$i-$suf"".log
	export THC_CACHING_ALLOCATOR=0
	eval "$CMD" & #> ~/`hostname`-$i"".out 2> ~/`hostname`-$i"".err" &
	echo $!  > ~/$i"".pid # $HOME/$HOST""-$i-$suf"".pid



#	for i in `seq 10`; do
#		nvidia-smi > ~/nvidia
#		sleep 1
#	done
	wait

	echo $CMD >> $par"".finished
	: > $par"".running

	i=$(($i+1))
done
