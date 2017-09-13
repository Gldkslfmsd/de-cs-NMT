#!/bin/bash

echo $1
echo $1.cs.pred
if [ ! -f $1.cs.pred ]; then
	echo translating
	time ../p2-onmt-py/bin/python ../OpenNMT-py/translate.py -model $1 -src test.de -output $1.cs.pred -replace_unk  -gpu 2 
fi
if [ ! -f $1.cs.pred.post ]; then
	./postprocess.sh < $1.cs.pred > $1.cs.pred.post
fi

if [ ! -f test.cs.post ]; then
	./postprocess.sh < test.cs > test.cs.post
fi

perl ../OpenNMT-py/tools/multi-bleu.perl test.cs.post < $1.cs.pred.post

