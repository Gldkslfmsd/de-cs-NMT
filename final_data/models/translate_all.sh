#!/bin/bash

all() {
	BPE=$1
	OSUB=$2
	TESTSUB=$3
	for B in $BPE; do
		for i in model-$OSUB""europarl-1gpu$B""*Z model-$OSUB""europarl-1gpu$B""*.t7 ; do 
			if [ -f $i"".cs.pred ]; then
				continue
			fi
			echo -n echo /lnet/spec/work/people/machacek/opennmt-experiments/de-cs-NMT/final_data/models/translate-eval.sh  
			echo -n ' '
			echo -n `realpath $i`
			echo -n ' '
			echo -n /lnet/spec/work/people/machacek/opennmt-experiments/de-cs-NMT/final_data/$OSUB""europarl/test.$TESTSUB""eup.bpe$B"".de 
			echo -n ' '
			echo -n "| qsub -q gpu.q -l gpu=1,gpu_cc_min3.5=1,gpu_ram=2G &"
			echo -n ' '
			echo
			echo
		done
	done
}

# osub:
# test.osub2-eup.bpe80000.de
all "30000 50000 80000" osub- osub2-

# europarl
# test.cs.prep.tok.bpe7500
all "7500 30000 50000 80000" "" ""

echo wait
