#!/bin/bash

BASE="th train.lua -data \$HOME/csen-data/csen-onmt-data-train.t7 "
BASE="$BASE  -gpuid 1 2 3 4 -async_parallel true -end_epoch 0"
BASE="$BASE -validation_metric perplexity -report_every 5000 -save_every 5000"
#BASE="$BASE -profiler true " 



echo '-src_word_vec_size  1000  -tgt_word_vec_size  1000  -dropout  0.1   -dropout_input  false  -dropout_words  0 -dropout_type naive
-src_word_vec_size  1000  -tgt_word_vec_size  1000  -dropout  0.1   -dropout_input  false  -dropout_words  0 -dropout_type naive
-src_word_vec_size  250   -tgt_word_vec_size  1000' > o3

echo '-dropout  0.1   -dropout_input  false  -dropout_words  0 -dropout_type naive
-dropout  0.1   -dropout_input  false  -dropout_words  0 -dropout_type naive
' > o3.2







#-rnn_size  500  -rnn_type  LSTM  -max_batch_size  1

echo '-rnn_size  500  -rnn_type  LSTM  -max_batch_size  1
-rnn_size  750  -rnn_type  LSTM  -max_batch_size  1
-rnn_size  250  -rnn_type  LSTM  -max_batch_size  1
-rnn_size  500  -rnn_type  LSTM  -max_batch_size  10
-rnn_size  250  -rnn_type  LSTM  -max_batch_size  10' > o2


echo '-enc_layers  2  -dec_layers  2  -bridge  none
-enc_layers  3  -dec_layers  3  -bridge  none' > o1




i=1
echo $i > i
#cat o3 | while read P3; do
	cat o2 | while read P2; do
		cat o1 | while read P1; do
			i=`cat i`
			CMD="$BASE $P3 $P2 $P1"
			CMD="$CMD -save_model /mnt/model4-$i-\$HOST"
			CMD="$CMD -log_file \$HOME/$i"".log"
			CMD="$CMD > \$HOME/$i"".out 2> \$HOME/$i"".err "
			echo $CMD
			i=$(($i+1))
			echo $i > i
		done
	done
#done

