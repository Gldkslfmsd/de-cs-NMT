#!/bin/bash

BASE="th train.lua -data \$HOME/data-50k/data-50k-train.t7 -save_model /mnt/model-\$HOST"
BASE="$BASE  -gpuid 1 2 3 4 -async_parallel false -sample 3000 -end_epoch 1"
BASE="$BASE -validation_metric perplexity -report_every 50 -save_every 5000"
#BASE="$BASE -profiler true " 

i=1
#for batch_size in 1  10 30 50 100 1000 10000; do
	for enc_layers in 1 3 4 ; do
		for dec_layers in 1 3 4 ; do
			for bridge in copy dense dense_nonlinear none; do
				if [[ $bridge == copy ]] && [[ $enc_layers -ne $dec_layers ]]; then
					continue
				fi
				for rnn_size in 250 750; do
					for rnn_type in LSTM GRU; do					
						CMD="$BASE" # -batch_size $batch_size"	
						CMD="$CMD -enc_layers $enc_layers"
						CMD="$CMD -dec_layers $dec_layers"
						CMD="$CMD -bridge $bridge -log_file \$HOME/$i"".log"
						CMD="$CMD > \$HOME/$i"".out 2> \$HOME/$i"".err"
#BASE="th train.lua -data data/demo-train.t7 -gpuid 1 2 3 4 -async_parallel false -sample 3000 -end_epoch 1"
#BASE="$BASE -validation_metric perplexity -report_every 50 -save_every 5000"
#						CMD="$BASE -save_model demo-model -log_file \$HOME/$i"".log"
						echo $CMD
						i=$(($i+1))
					done
				done
			done
		done
	done
#done
