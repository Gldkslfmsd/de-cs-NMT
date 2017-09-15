
preprocess:
	python ../OpenNMT-py/preprocess.py -train_src train.de -train_tgt train.cs -valid_src dev.de -valid_tgt dev.cs -save_data demo


train_model-01:
	python ../OpenNMT-py/train.py -data model-01 -save_model model-01/model -gpuid 1 -seed 123

train-2:
	python ../OpenNMT-py/train.py -data model-01 -save_model model-02/model -gpuid 2 -seed 1111

continue-training:
	python ../OpenNMT-py/train.py -data model-01 \
		-save_model model-03/model \
		-gpuid 2 \
		-seed 123 \
		-epochs 1000 \
		-train_from model-03/model_acc_50.70_ppl_20.14_e14.pt

# randomly selected hyperparameters
train-4:
	python ../OpenNMT-py/train.py -data model-01 \
		-save_model model-04/model \
		-gpuid 1 \
		-seed 124 \
		-epochs 1000 \
		-layers 2
		-train_from model-04/model_acc_35.22_ppl_72.02_e1.pt

		#-encoder_type transformer -decoder_type transformer #  
#		-tgt_word_vec_size 128 -src_word_vec_size 64 


translate:
	python ../OpenNMT-py/translate.py -model model-01/model_acc_40.83_ppl_42.55_e2.pt -src test.de -output test-pred.cs -replace_unk -verbose -gpu 2

MOSES=data/moses/scripts/tokenizer
baseline: data/moses
	curl http://matrix.statmt.org/data/20130503220932_U-31_S-1894_T-1715_sysout.cs.normalized.sgml?1367615372 | sed 's/<[^>]*>//g' | grep . | \
		perl $(MOSES)/remove-non-printing-char.perl | \
		perl $(MOSES)/replace-unicode-punctuation.perl | \
		perl $(MOSES)/normalize-punctuation.perl | \
		perl $(MOSES)/tokenizer.perl -no-escape -threads `nproc` -l cs | \
		perl multi-bleu.perl data/test.cs.prep.tok

ONMT=/home/obo-machacek/OpenNMT
D=/home/obo-machacek/de-cs-NMT
.ONESHELL:
preprocess-a:
	cd $(ONMT)
	th preprocess.lua \
        -train_src $D/train.de.prep.tok.mor \
        -train_tgt $D/train.cs.prep.tok.mor \
        -valid_src $D/dev.de.prep.tok.mor \
        -valid_tgt $D/dev.cs.prep.tok.mor \
        -save_data $D/data
#       -seed 123 \
#       -epochs 100

C=4
.ONESHELL:
train4:
	cd $(ONMT)
#       source /home/obo-machacek/.bashrc
	nohup th train.lua -data $D/data-train.t7 \
        -save_config conf$C \
        -gpuid 1 2 3 4 \
        -end_epoch 0 \
        -async_parallel true \
        -max_batch_size 512 \
        -seed 123 \
        -log_file /home/obo-machacek/train$C.log \
        -report_every 1000 \
        -save_every 1000 \
        -save_model $D/model$C > /home/obo-machacek/train$C.out &
	echo $$! > /home/obo-machacek/train4.pid

C=5
.ONESHELL:
train5:
	cd $(ONMT)
#       source /home/obo-machacek/.bashrc
	nohup th train.lua -data $D/data-train.t7 \
        -save_config conf$C \
        -gpuid 1 2 3 4 \
        -end_epoch 0 \
        -async_parallel true \
        -max_batch_size 512 \
        -seed 123 \
        -log_file /home/obo-machacek/train$C.log \
        -report_every 500 \
        -save_every 50 \
	-validation_metric bleu \
        -save_model /mnt/obo-machacek/model$C > /home/obo-machacek/train$C.out &
	echo $$! > /home/obo-machacek/train4.pid

train.de.bpe: data/train.de.prep.tok.bpe7500
	cp data/train.de.prep.tok.bpe7500 train.de.bpe
train.cs.bpe: data/train.cs.prep.tok.bpe7500
	cp data/train.cs.prep.tok.bpe7500 train.cs.bpe
dev.cs.bpe:
	cp data/dev.cs.prep.tok.bpe7500 dev.cs.bpe
dev.de.bpe:
	cp data/dev.de.prep.tok.bpe7500 dev.de.bpe


.ONESHELL:
preprocess-bpe: dev.de.bpe dev.cs.bpe train.cs.bpe train.de.bpe
	cd $(ONMT)
	th preprocess.lua \
        -train_src $D/train.de.bpe \
        -train_tgt $D/train.cs.bpe \
        -valid_src $D/dev.de.bpe \
        -valid_tgt $D/dev.cs.bpe \
        -save_data $D/data-bpe

C=bpe1
.ONESHELL:
train-bpe1:
	cd $(ONMT)
	nohup th train.lua -data $D/data-bpe-train.t7 \
        -save_config conf$C \
        -gpuid 1 2 3 4 \
        -end_epoch 0 \
        -async_parallel true \
        -max_batch_size 64 \
        -seed 123 \
        -log_file /home/obo-machacek/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric perplexity \
        -save_model /mnt/obo-machacek/model$C > /home/obo-machacek/train$C.out &

C=bpe2
.ONESHELL:
train-bpe2:
	cd $(ONMT)
	nohup th train.lua -data $D/data-bpe-train.t7 \
        -save_config conf$C \
        -gpuid 1  \
        -end_epoch 0 \
	-layers 1 \
        -max_batch_size 64 \
	-rnn_type GRU \
        -seed 123 \
        -log_file /home/obo-machacek/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric loss \
        -save_model /mnt/obo-machacek/model$C > /home/obo-machacek/train$C.out &

#C=bpe3
.ONESHELL:
train-bpe3:
	cd $(ONMT)
	nohup th train.lua -data $D/data-bpe-train.t7 \
        -save_config conf$C \
        -gpuid  3 4 \
        -end_epoch 0 \
        -async_parallel true \
        -max_batch_size 64 \
        -seed 123 \
        -log_file /home/obo-machacek/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric perplexity \
        -save_model /mnt/obo-machacek/model$C > /home/obo-machacek/train$C.out &

C=bpe4
.ONESHELL:
train-bpe4:
	cd $(ONMT)
	nohup th train.lua -data $D/data-bpe-train.t7 \
        -save_config conf$C \
        -gpuid 2  \
        -end_epoch 0 \
	-layers 3 \
        -max_batch_size 64 \
        -seed 123 \
        -log_file /home/obo-machacek/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric loss \
        -save_model /mnt/obo-machacek/model$C > /home/obo-machacek/train$C.out &
