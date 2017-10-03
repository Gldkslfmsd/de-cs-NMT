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

header() {
	CMD="$BASE $PARAMS" 
	CMD="$CMD -enc_layers $enc_layers"
	CMD="$CMD -dec_layers $dec_layers"
	CMD="$CMD -encoder_type $encoder_type"
	CMD="$CMD -attention $attention"
	CMD="$CMD -bridge dense_nonlinear"
	echo $CMD
}


footer() {
	CMD="$2 -log_file \$HOME/$1"".log"
	CMD="$CMD -save_model /mnt/model3-$1-\$HOST"
	CMD="$CMD > \$HOME/$1"".out 2> \$HOME/$1"".err "
	echo $CMD
}
		

for	enc_layers in 2 3 ; do
	for dec_layers in 2 3; do 
		for encoder_type  in rnn brnn dbrnn pdbrnn gnmt cnn; do
			for attention in none global; do

				if [ "$encoder_type" == brnn ]; then
					for brnn_merge in concat sum; do
						CMD=`header`
						CMD="$CMD -brnn_merge $brnn_merge "
						footer "$i" "$CMD"				
						i=$(($i+1))
					done
				else if [ "$encoder_type" == pdbrnn ]; then
					for pdbrnn_reduction in 1 2 3; do
						for pdbrnn_merge in concat sum; do
							CMD=`header`
							CMD="$CMD -pdbrnn_reduction $pdbrnn_reduction"
							CMD="$CMD -pdbrnn_merge $pdbrnn_merge"
							footer "$i" "$CMD"
							i=$(($i+1))
						done
					done
				else if [ "$encoder_type" == cnn ]; then
#					for cnn_layers in 1 2 3; do
						for cnn_kernel in 2 3 4; do
							for cnn_size in 250 500 750; do
								CMD=`header`
#								if [ ! $cnn_layers -eq 1 ]; then
#									CMD="$CMD -cnn_layers $cnn_layers"
#								fi
								CMD="$CMD -cnn_kernel $cnn_kernel"
								CMD="$CMD -cnn_size $cnn_size"
								footer "$i" "$CMD"
								i=$(($i+1))
							done
						done
#					done
				else 
					footer "$i" "$CMD"
					i=$(($i+1))
				fi
				fi
				fi
			done
		done
	done
done


				
