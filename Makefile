
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

BPE=2500
train.de.bpe$(BPE): #data/train.de.prep.tok.bpe$(BPE)
	cp data/train.de.prep.tok.bpe$(BPE) train.de.bpe$(BPE)
train.cs.bpe$(BPE): #data/train.cs.prep.tok.bpe$(BPE)
	cp data/train.cs.prep.tok.bpe$(BPE) train.cs.bpe$(BPE)
dev.cs.bpe$(BPE):
	cp data/dev.cs.prep.tok.bpe$(BPE) dev.cs.bpe$(BPE)
dev.de.bpe$(BPE):
	cp data/dev.de.prep.tok.bpe$(BPE) dev.de.bpe$(BPE)


.ONESHELL:
preprocess-bpe: dev.de.bpe$(BPE) dev.cs.bpe$(BPE) train.cs.bpe$(BPE) train.de.bpe$(BPE)
	cd $(ONMT)
	th preprocess.lua \
        -train_src $D/train.de.bpe$(BPE) \
        -train_tgt $D/train.cs.bpe$(BPE) \
        -valid_src $D/dev.de.bpe$(BPE) \
        -valid_tgt $D/dev.cs.bpe$(BPE) \
        -save_data $D/data-bpe$(BPE)

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

###################################################################################################
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

C=bpe2.2
.ONESHELL:
train-bpe2.2:
	cd $(ONMT)
	nohup th train.lua -data $D/data-bpe-train.t7 \
        -save_config conf$C \
        -gpuid 1  \
        -end_epoch 0 \
	-layers 2 \
        -max_batch_size 64 \
	-rnn_type GRU \
        -seed 123 \
        -log_file /home/obo-machacek/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric loss \
        -save_model /mnt/obo-machacek/model$C > /home/obo-machacek/train$C.out &
	echo $! > /home/obo-machacek/train$C.pid

####################################################################################################

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


C=bpe3.2
.ONESHELL:
train-bpe3.2:
	cd $(ONMT)
	nohup th train.lua -data $D/data-bpe$(BPE)-train.t7 \
        -save_config conf$C \
        -gpuid  4 \
        -end_epoch 0 \
        -async_parallel false \
        -max_batch_size 64 \
        -seed 123 \
        -log_file /home/obo-machacek/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric perplexity \
        -save_model /mnt/obo-machacek/model$C > /home/obo-machacek/train$C.out &
	echo $! > /home/obo-machacek/train$C.pid

####################################################################################################


#C=bpe4
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

#C=bpe4.2
.ONESHELL:
train-bpe4.2:
	cd $(ONMT)
	nohup th train.lua -data $D/data-bpe-train.t7 \
        -save_config conf$C \
        -gpuid 3  \
        -end_epoch 0 \
	-layers 4 \
        -max_batch_size 64 \
        -seed 123 \
        -log_file /home/obo-machacek/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric loss \
        -save_model /mnt/obo-machacek/model$C > /home/obo-machacek/train$C.out &



####################################################################################################
# pretrain word vectors:

DIR=/mnt/obo-machacek/vectors

$(DIR)/data.de:
	gunzip -c /home/obo-machacek/de-cs-NMT/data/w2c/web.de.txt.prep.tok.bpe7500.gz > $(DIR)/data.de

$(DIR)/data.cs:
	gunzip -c /home/obo-machacek/de-cs-NMT/data/w2c/web.cs.txt.prep.tok.bpe7500.gz > $(DIR)/data.cs

.ONESHELL:
dicts $(DIR)/vocab.de $(DIR)/vocab.cs: $(DIR)/data.de $(DIR)/data.cs
	mkdir -p $(DIR)
	cd $(ONMT)
	th tools/build_vocab.lua -save_vocab $(DIR)/vocab.de -words_min_frequency 2 -data $(DIR)/data.de &
	th tools/build_vocab.lua -save_vocab $(DIR)/vocab.cs -words_min_frequency 2 -data $(DIR)/data.cs
	wait


.ONESHELL:
embed:
	cd $(ONMT)
	th tools/embeddings.lua -dict_file $(DIR)/vocab.de.dict -save_data $(DIR)/emb.de -embed_file ~/de-cs-NMT/vec.de -embed_type word2vec-bin

.ONESHELL:
preprocess-sub:
	cd $(ONMT)
	th preprocess.lua -train_src $$HOME/de-cs-NMT/data/osub.de.bpe -train_tgt $$HOME/de-cs-NMT/data/osub.cs.bpe -valid_src $$HOME/de-cs-NMT/data/dev.de.prep.tok.bpe7500 -valid_tgt $$HOME/de-cs-NMT/data/dev.cs.prep.tok.bpe7500 -save_data /mnt/obo-machacek/subtitles/data-osub


DATA=/mnt/obo-machacek/subtitles/data-osub-train.t7
C=osub-1
.ONESHELL:
train$C:
	cd $(ONMT)
	nohup th train.lua -data $(DATA) \
        -save_config conf$C \
        -gpuid 1 2 3 4  \
        -end_epoch 13 \
        -max_batch_size 64 \
        -seed 123 \
        -log_file $$HOME/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric perplexity \
        -save_model /mnt/obo-machacek/model$C > $$HOME/train$C.out &


C=osub-2
.ONESHELL:
train$C:
	cd $(ONMT)
	THC_CACHING_ALLOCATOR=0 nohup th train.lua -data $(DATA) \
        -save_config conf$C \
        -gpuid 1 2 3 4  \
        -end_epoch 13 \
        -max_batch_size 1024 \
        -seed 123 \
        -log_file $$HOME/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric perplexity \
        -save_model /mnt/obo-machacek/model$C > $$HOME/train$C.out &

#C=osub-3
.ONESHELL:
train$C:
	cd $(ONMT)
	THC_CACHING_ALLOCATOR=0 nohup th train.lua -data $(DATA) \
        -save_config conf$C \
        -gpuid 1 2 3 4  \
        -end_epoch 13 \
        -max_batch_size 1024 \
        -seed 123 \
        -log_file $$HOME/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric loss \
        -save_model /mnt/obo-machacek/model$C > $$HOME/train$C.out &

#C=osub-4
.ONESHELL:
train$C:
	cd $(ONMT)
	THC_CACHING_ALLOCATOR=0 nohup th train.lua -data $(DATA) \
        -save_config conf$C \
        -gpuid 1 2 3 4  \
        -end_epoch 13 \
        -max_batch_size 1024 \
	-layers 3 \
        -seed 123 \
        -log_file $$HOME/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric perplexity \
        -save_model /mnt/obo-machacek/model$C > $$HOME/train$C.out &

#C=osub-5
.ONESHELL:
train$C:
	cd $(ONMT)
	THC_CACHING_ALLOCATOR=0 nohup th train.lua -data $(DATA) \
        -save_config conf$C \
        -gpuid 1 2 3 4  \
        -end_epoch 13 \
	-layers 3 \
        -max_batch_size 64 \
        -seed 123 \
        -log_file $$HOME/train$C.log \
        -report_every 50 \
        -save_every 50 \
	-validation_metric perplexity \
        -save_model /mnt/obo-machacek/model$C > $$HOME/train$C.out &
