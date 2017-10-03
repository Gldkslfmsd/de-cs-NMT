#!/bin/bash

BASE="th train.lua -data \$HOME/csen-data/csen-onmt-data-train.t7 "
BASE="$BASE  -gpuid 1 2 3 4 -async_parallel true -end_epoch 0"
BASE="$BASE -report_every 5000 -save_every 5000"
#BASE="$BASE -profiler true " 

PERP="$BASE -validation_metric perplexity" 

foot() {
echo "-save_model /mnt/model$1-\$HOST -log_file \$HOME/$1"".log > \$HOME/$1"".out 2> \$HOME/$1"".err"
}

i=x1

echo $PERP -rnn_size 500 -rnn_type LSTM -max_batch_size 1 -enc_layers 2 -dec_layers 2 -bridge none `foot $i`

i=x3

#echo $PERP -rnn_size 750 -rnn_type LSTM -max_batch_size 1 -enc_layers 2 -dec_layers 2 -bridge none `foot $i`

i=x4

echo $PERP -rnn_type LSTM -max_batch_size 1 -enc_layers 3 -dec_layers 3 -bridge none `foot $i` 

i=x5

#echo $PERP -rnn_size 250 -rnn_type LSTM -max_batch_size 1 -enc_layers 2 -dec_layers 2 -bridge none `foot $i`

i=x6

echo $PERP -rnn_size 250 -rnn_type LSTM -max_batch_size 1 -enc_layers 3 -dec_layers 3 -bridge none `foot $i`

BEST4="-src_word_vec_size  1000  -tgt_word_vec_size  1000 -dropout  0.1 -dropout_input false  -dropout_words  0    -dropout_type naive"

i=11
echo $PERP $BEST4 `foot $i`

i=$(($i+1))

echo $PERP $BEST4 -rnn_size  500  -rnn_type  LSTM -max_batch_size 1 `foot $i`

i=$(($i+1))

echo $PERP $BEST4 -rnn_size  500  -rnn_type  LSTM -max_batch_size 64 `foot $i`

i=$(($i+1))

echo $BASE -validation_metric loss $BEST4 -rnn_size  500  -rnn_type  LSTM -max_batch_size 64 `foot $i`

i=$(($i+1))

echo $BASE -validation_metric bleu  $BEST4 -rnn_size  500  -rnn_type  LSTM -max_batch_size 64 `foot $i`

i=$(($i+1))

#echo $BASE -validation_metric ter  $BEST4 -rnn_size  500  -rnn_type  LSTM -max_batch_size 64 `foot $i`
echo $PERP -optim adagrad -learning_rate 0.1 -max_batch_size 256 $BEST4 `foot $i`


i=$(($i+1))

echo $BASE -validation_metric dlratio  $BEST4 -rnn_size  500  -rnn_type  LSTM -max_batch_size 64 `foot $i`

i=$(($i+1))

echo $PERP -optim adagrad -learning_rate 0.1 $BEST4 `foot $i`

i=$(($i+1))

echo $PERP -optim adadelta -learning_rate 0.1 $BEST4 `foot $i`

i=$(($i+1))

echo $PERP -optim adam -learning_rate 0.0002 $BEST4 `foot $i`

i=$(($i+1))

echo $BASE -validation_metric bleu $BEST4  -optim adam -learning_rate 0.0002 `foot $i`
