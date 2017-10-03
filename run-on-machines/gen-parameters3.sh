#!/bin/bash

BASE="th train.lua -data \$HOME/csen-data/csen-onmt-data-train.t7 "
BASE="$BASE  -gpuid 1 2 3 4 -async_parallel false -sample 50000 -end_epoch 1"
BASE="$BASE -validation_metric perplexity -report_every 50 -save_every 500"
#BASE="$BASE -profiler true " 

i=1

PARAMS="-enc_layers  3  -dec_layers  1  -bridge  dense_nonlinear
  -enc_layers  4  -dec_layers  1  -bridge  none
  -enc_layers  3  -dec_layers  1  -bridge  dense
  -enc_layers  3  -dec_layers  3  -bridge  none
  -enc_layers  2  -dec_layers  2  -bridge  none
  "

PARAMS="-rnn_size  500  -rnn_type  LSTM  -max_batch_size  1"
		
for src_word_vec_size in 100 250 500 750 1000; do
	for tgt_word_vec_size in 100 250 500 750 1000; do					
		CMD="$BASE $PARAMS" 
		CMD="$CMD -src_word_vec_size $src_word_vec_size "
		CMD="$CMD -tgt_word_vec_size $tgt_word_vec_size "
		CMD="$CMD -log_file \$HOME/$i"".log"
		CMD="$CMD -save_model /mnt/model3-$i-\$HOST"
		CMD="$CMD > \$HOME/$i"".out 2> \$HOME/$i"".err"
		echo $CMD
		i=$(($i+1))
	done
done


for dropout in 0.1 0.3 0.5 0.75; do
	for dropout_input in true false; do 
		for dropout_words in 0 0.1 0.3; do
			for dropout_type in  naive variational; do
				for residual in true false; do
					CMD="$BASE $PARAMS" 
					CMD="$CMD -src_word_vec_size $src_word_vec_size "
					CMD="$CMD -tgt_word_vec_size $tgt_word_vec_size "
					CMD="$CMD -dropout $dropout "
					CMD="$CMD -dropout_input $dropout_input "
					CMD="$CMD -dropout_words $dropout_words "
					CMD="$CMD -dropout_type $dropout_type "
					
					CMD="$CMD -log_file \$HOME/$i"".log"
					CMD="$CMD -save_model /mnt/model3-$i-\$HOST"
					CMD="$CMD > \$HOME/$i"".out 2> \$HOME/$i"".err"
					echo $CMD
					i=$(($i+1))
				done
			done
		done
	done
done
