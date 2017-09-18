#!/bin/bash
# < params
cd OpenNMT
i=1
HOST=`hostname`
while read line; do
	suf=`echo $line | sed 's/ /_/g'`
	echo
	echo
	echo $suf 
	echo
	echo
	echo
	echo $line #-log_file $HOME/$HOST""-$i-$suf"".log
	eval "$line > ~/`hostname`-$i"".out 2>`hostname`-$i"".err" 
	echo $!  > ~/$i"".pid # $HOME/$HOST""-$i-$suf"".pid

#	for i in `seq 10`; do
#		nvidia-smi > ~/nvidia
#		sleep 1
#	done
	wait

	i=$(($i+1))
done
