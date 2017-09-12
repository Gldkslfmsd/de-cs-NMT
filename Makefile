
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


