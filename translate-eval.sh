#!/bin/bash

echo $1
echo $1.cs.pred
MODEL=`realpath $1`
WD=$(pwd)
if [ ! -f $WD/$1.cs.pred ]; then
	echo translating
	cd $HOME/OpenNMT
	echo $WD
	time th translate.lua -model $MODEL -src $WD/test.de -output $WD/$1.cs.pred -replace_unk -gpuid 3
fi
cd $WD
if [ ! -f $1.cs.pred.post ]; then
	./postprocess.sh < $1.cs.pred > $1.cs.pred.post
fi

if [ ! -f test.cs.post ]; then
	./postprocess.sh < test.cs > test.cs.post
fi

perl multi-bleu.perl test.cs.post < $1.cs.pred.post

