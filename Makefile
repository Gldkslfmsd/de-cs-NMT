
preprocess:
	python ../OpenNMT-py/preprocess.py -train_src train.de -train_tgt train.cs -valid_src dev.de -valid_tgt dev.cs -save_data demo


train_model-01:
	python ../OpenNMT-py/train.py -data model-01 -save_model model-01/model -gpuid 1 -seed 123

train-2:
	python ../OpenNMT-py/train.py -data model-01 -save_model model-02/model -gpuid 2 -seed 1111

translate:
	python ../OpenNMT-py/translate.py -model model-01/model_acc_40.83_ppl_42.55_e2.pt -src test.de -output test-pred.cs -replace_unk -verbose -gpu 2
