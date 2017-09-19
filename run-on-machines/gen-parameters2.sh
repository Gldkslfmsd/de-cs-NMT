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
		
#for params in `cat best`; do
	for rnn_size in 250 750 500; do
		for rnn_type in LSTM GRU; do					
			for max_batch_size in 1 10 30 50 100 1000 10000; do
				CMD="$BASE" # -batch_size $batch_size"	
#				CMD="$CMD $params"
				CMD="$CMD -rnn_size $rnn_size"
				CMD="$CMD -rnn_type $rnn_type"
				CMD="$CMD -max_batch_size $max_batch_size"
				CMD="$CMD -log_file \$HOME/$i"".log"
				CMD="$CMD -save_model /mnt/model2-$i-\$HOST"
				CMD="$CMD > \$HOME/$i"".out 2> \$HOME/$i"".err"
				echo $CMD
				i=$(($i+1))
			done
		done
	done
#done
