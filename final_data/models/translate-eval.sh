#!/bin/bash

gpu_cards() {
	echo $CUDA_VISIBLE_DEVICES | sed 's/,/ /g' | python3 -c 'print(" ".join(map(lambda x:str(int(x)+1),input().split())))'
}

MODEL=`realpath $1`
TEST=`realpath $2`
DEV=$3
OUT=$MODEL"".cs.$DEV""pred
POST=$OUT"".post
WD=$(pwd)
if [ ! -f $MODEL"".cs.$DEV""pred ]; then
	echo translating
	cd /net/work/people/machacek/opennmt-experiments/OpenNMT
	th translate.lua -model $MODEL -src $TEST -output $OUT -replace_unk -gpuid 1 #`gpu_cards`
fi

cd $WD
if [ ! -f $POST ]; then
	sed 's/@@ //g' < $OUT > $POST
fi

EVAL=multi-bleu.perl

# TODO: mteval needs some dependencies...
#EVAL=mteval-v14.pl

if [ ! -z "$3" ]; then
	perl $EVAL /net/work/people/machacek/opennmt-experiments/de-cs-NMT/final_data/test.cs.post < $POST 2>/dev/null
else
	perl $EVAL /net/work/people/machacek/opennmt-experiments/de-cs-NMT/final_data/dev.cs.post < $POST 2>/dev/null
fi


