all: tokenize

install_moses moses:
	wget https://github.com/moses-smt/mosesdecoder/archive/mmt-mvp-v0.12.1.zip -O moses.zip
	unzip moses.zip
	mv mosesdecoder-mmt-mvp-v0.12.1/ moses

DATA_CS=train.cs test.cs dev.cs
DATA_DE=train.de test.de dev.de
DATA=$(DATA_CS) $(DATA_DE)

DATA.prep=train.cs.prep test.cs.prep dev.cs.prep train.de.prep test.de.prep dev.de.prep
data $(DATA):
	make -C europarl
	cp europarl/europarl.cs train.cs 
	cp europarl/europarl.de train.de
	make -C news13_test
	cp news13_test/news13.cs test.cs 
	cp news13_test/news13.de test.de
	make -C news11_dev
	cp news11_dev/news11.cs dev.cs 
	cp news11_dev/news11.de dev.de



MOSES=moses/scripts/tokenizer
preprocess $(DATA.prep): $(DATA) moses
	for d in $(DATA); do \
		echo $$d ; \
		cat $$d | \
		./preprocess.sh > $$d"".prep ;\
	done

TOKENIZED=dev.cs.prep.tok dev.de.prep.tok train.cs.prep.tok test.cs.prep.tok train.de.prep.tok test.de.prep.tok	
TOK_CMD=perl $(MOSES)/tokenizer.perl -no-escape -threads `nproc`
tokenize $(TOKENIZED): moses $(DATA.prep) $(DATA)
	for d in $(DATA_CS); do	\
		echo $$d"".prep ; \
		$(TOK_CMD) -l cs < $$d"".prep > $$d"".prep.tok; \
	done
	for d in $(DATA_DE); do	\
		echo $$d"".prep ; \
		$(TOK_CMD) -l de < $$d > $$d"".prep.tok; \
	done

#############################################################
# w2c corpus

B=30000

w2c/web.de.txt.gz:
	make -C w2c web.de.txt.gz
w2c/web.cs.txt.gz:
	make -C w2c web.cs.txt.gz


tokenize_w2c: w2c/web.de.txt.gz w2c/web.cs.txt.gz
	gunzip -c w2c/web.cs.txt.gz | ./preprocess.sh | $(TOK_CMD) -l cs  | gzip > w2c/web.cs.txt.prep.tok.gz &
	gunzip -c w2c/web.de.txt.gz | ./preprocess.sh | $(TOK_CMD) -l de  | gzip > w2c/web.de.txt.prep.tok.gz
	wait

	
w2c_bpe: w2c/web.de.txt.prep.tok.gz w2c/web.cs.txt.prep.tok.gz
	gunzip -c w2c/web.cs.txt.prep.tok.gz | subword/apply_bpe.py -c model_bpe$B.cs | gzip > w2c/web.cs.txt.prep.tok.bpe$B.gz &
	gunzip -c w2c/web.de.txt.prep.tok.gz | subword/apply_bpe.py -c model_bpe$B.de | gzip > w2c/web.de.txt.prep.tok.bpe$B.gz
	wait




#############################################################
# Morfessor

install_morfessor p3:
	virtualenv -p python3 p3
	p3/bin/pip install morfessor polyglot pyicu six pycld2 numpy
	p3/bin/python3 -c 'from polyglot.downloader import downloader; downloader.download("morph2.cs"); downloader.download("morph2.de")'

morfesize: morphesize.py $(TOKENIZED)
	for d in $(DATA_CS); do	\
		echo $$d"".prep.tok ; \
		p3/bin/python3 morphesize.py cs < $$d"".prep.tok > $$d"".prep.tok.mor & \
	done
	wait
	for d in $(DATA_DE); do	\
		echo $$d"".prep.tok ; \
		p3/bin/python3 morphesize.py de < $$d"".prep.tok > $$d"".prep.tok.mor & \
	done
	wait


############################################################################################################################################
# Byte pair encoding

subword:
	git clone https://github.com/rsennrich/subword-nmt.git subword

rewrite=! # ! if not rewrite, nothing if yes
#PARAM=100 1000 2500 5000 7500 10000 15000 18000 20000 50000 100000 1000000
PARAM=30000 50000 80000
analyze_bpe: $(TOKENIZED) subword
	for s in $(PARAM); do \
		{ \
			echo $$s ; \
			[ $(rewrite) -f model_bpe$$s.cs ] && subword/learn_bpe.py -s $$s < train.cs.prep.tok > model_bpe$$s.cs & \
			[ $(rewrite) -f model_bpe$$s.de ] && subword/learn_bpe.py -s $$s < train.de.prep.tok > model_bpe$$s.de & \
			wait ; echo learned ; \
			[ $(rewrite) -f train.cs.prep.tok.bpe$$s ] && subword/apply_bpe.py -c model_bpe$$s.cs < train.cs.prep.tok > train.cs.prep.tok.bpe$$s & \
			[ $(rewrite) -f train.de.prep.tok.bpe$$s ] && subword/apply_bpe.py -c model_bpe$$s.de < train.de.prep.tok > train.de.prep.tok.bpe$$s & \
			[ $(rewrite) -f dev.de.prep.tok.bpe$$s ] && subword/apply_bpe.py -c model_bpe$$s.de < dev.de.prep.tok > dev.de.prep.tok.bpe$$s & \
			[ $(rewrite) -f dev.cs.prep.tok.bpe$$s ] && subword/apply_bpe.py -c model_bpe$$s.cs < dev.cs.prep.tok > dev.cs.prep.tok.bpe$$s & \
			wait ; echo applied; \
			echo; echo; echo de $$s; echo; \
			[ $(rewrite) -f pbe$$s.de.oov ] && perl $(MOSES)/../analysis/oov.pl dev.de.prep.tok.bpe$$s < train.de.prep.tok.bpe$$s > pbe$$s.de.oov & \
			echo; echo; echo cs $$s; echo; \
			[ $(rewrite) -f pbe$$s.cs.oov ] && perl $(MOSES)/../analysis/oov.pl dev.cs.prep.tok.bpe$$s < train.cs.prep.tok.bpe$$s > pbe$$s.cs.oov & \
		} & \
	done ; 	wait
		

print_bpe_oov:
	for s in $(PARAM); do \
		echo; echo cs $$s; echo; \
		cat pbe$$s.cs.oov ; done
	echo
	echo =======================
	echo
	for s in $(PARAM); do \
		echo ; echo de $$s; echo; \
		cat pbe$$s.de.oov ; done

	
	

oov_analysis: $(TOKENIZED)
	perl $(MOSES)/../analysis/oov.pl dev.cs.prep.tok < train.cs.prep.tok
	perl $(MOSES)/../analysis/oov.pl dev.de.prep.tok < train.de.prep.tok
	perl $(MOSES)/../analysis/oov.pl dev.cs.prep.tok.mor < train.cs.prep.tok.mor
	perl $(MOSES)/../analysis/oov.pl dev.de.prep.tok.mor < train.de.prep.tok.mor

check_overlap: $(TOKENIZED)
	python3 check_overlap.py train.cs.prep.tok test.cs.prep.tok	
	python3 check_overlap.py train.de.prep.tok test.de.prep.tok
	python3 check_overlap.py train.cs.prep.tok dev.cs.prep.tok	
	python3 check_overlap.py train.de.prep.tok dev.de.prep.tok
	python3 check_overlap.py test.de.prep.tok dev.de.prep.tok
	python3 check_overlap.py test.cs.prep.tok dev.cs.prep.tok

clean_data:
	rm -rf dev* train* test*



#####################################################
# osub

DIR=/mnt/obo-machacek/subtitles

osub.cs:
	make -C subtitles osub.cs
	-ln -s subtitles/osub.cs .
	mkdir -p $(DIR)

osub.de:
	#make -C subtitles osub.de
	-ln -s subtitles/osub.de .


$(DIR)/osub.cs.prep: osub.cs moses
	./preprocess.sh < osub.cs > $(DIR)/osub.cs.prep
$(DIR)/osub.de.prep: osub.de
	./preprocess.sh < osub.de > $(DIR)/osub.de.prep

$(DIR)/osub.de.prep.tok: $(DIR)/osub.de.prep moses
	$(TOK_CMD) -l de <  $(DIR)/osub.de.prep > $(DIR)/osub.de.prep.tok
$(DIR)/osub.cs.prep.tok: $(DIR)/osub.cs.prep moses
	$(TOK_CMD) -l cs <  $(DIR)/osub.cs.prep > $(DIR)/osub.cs.prep.tok

B=7500

osub_model_bpe$B.cs: $(DIR)/osub.cs.prep.tok subword
	subword/learn_bpe.py -s $B < $(DIR)/osub.cs.prep.tok > osub_model_bpe$B.cs
osub_model_bpe$B.de: $(DIR)/osub.de.prep.tok subword
	subword/learn_bpe.py -s $B < $(DIR)/osub.de.prep.tok > osub_model_bpe$B.de

$(DIR)/osub.cs.prep.tok.bpe$B: $(DIR)/osub.cs.prep.tok osub_model_bpe$B.cs
	subword/apply_bpe.py -c osub_model_bpe$B.cs < $(DIR)/osub.cs.prep.tok > $(DIR)/osub.cs.prep.tok.bpe$B
$(DIR)/osub.de.prep.tok.bpe$B: $(DIR)/osub.de.prep.tok  osub_model_bpe$B.de
	subword/apply_bpe.py -c osub_model_bpe$B.de < $(DIR)/osub.de.prep.tok > $(DIR)/osub.de.prep.tok.bpe$B

osub.cs.bpe: $(DIR)/osub.cs.prep.tok.bpe$B
	ln -s $(DIR)/osub.cs.prep.tok.bpe$B osub.cs.bpe
osub.de.bpe: $(DIR)/osub.de.prep.tok.bpe$B
	ln -s $(DIR)/osub.de.prep.tok.bpe$B osub.de.bpe


#####################################################
# osub-v2

DIR=/mnt/obo-machacek/subtitles

BB=7500 30000 50000 80000

osub-v2-models:
	for i in $(BB); do make B=$$i osub_model_clear_bpe$$i.cs  osub_model_clear_bpe$$i.de -j & done ; wait

osub-v2:
	for i in $(BB); do make B=$$i $(DIR)/osub.cs.prep.tok.clear.bpe$$i $(DIR)/osub.de.prep.tok.clear.bpe$$i -j & done ; wait
eup-v2:
	for i in $(BB); do make B=$$i $(DIR)/eup.cs.bpe$$i $(DIR)/eup.de.bpe$$i -j & done ; wait

eup-osub-v2:
	for i in $(BB); do cat $(DIR)/eup.de.bpe$$i $(DIR)/osub.de.prep.tok.clear.bpe$$i > $(DIR)/osub2-eup.de.bpe$$i & cat $(DIR)/eup.cs.bpe$$i $(DIR)/osub.cs.prep.tok.clear.bpe$$i > $(DIR)/osub2-eup.cs.bpe$$i & done ; wait



osub_model_clear_bpe$B.cs: $(DIR)/osub.cs.prep.tok.clear subword
	subword/learn_bpe.py -s $B < $(DIR)/osub.cs.prep.tok.clear > osub_model_clear_bpe$B.cs
osub_model_clear_bpe$B.de: $(DIR)/osub.de.prep.tok.clear subword
	subword/learn_bpe.py -s $B < $(DIR)/osub.de.prep.tok.clear > osub_model_clear_bpe$B.de

$(DIR)/osub.cs.prep.tok.clear.bpe$B: $(DIR)/osub.cs.prep.tok.clear osub_model_clear_bpe$B.cs
	subword/apply_bpe.py -c osub_model_clear_bpe$B.cs < $(DIR)/osub.cs.prep.tok.clear > $(DIR)/osub.cs.prep.tok.clear.bpe$B
$(DIR)/osub.de.prep.tok.clear.bpe$B: $(DIR)/osub.de.prep.tok.clear  osub_model_clear_bpe$B.de
	subword/apply_bpe.py -c osub_model_clear_bpe$B.de < $(DIR)/osub.de.prep.tok.clear > $(DIR)/osub.de.prep.tok.clear.bpe$B

$(DIR)/eup.de.bpe$B: osub_model_clear_bpe$B.de
	subword/apply_bpe.py -c osub_model_clear_bpe$B.de < train.de.prep.tok > $(DIR)/eup.de.bpe$B
$(DIR)/eup.cs.bpe$B: osub_model_clear_bpe$B.cs
	subword/apply_bpe.py -c osub_model_clear_bpe$B.cs < train.cs.prep.tok > $(DIR)/eup.cs.bpe$B
	

osub.cs.clear.bpe: $(DIR)/osub.cs.prep.tok.bpe$B
	ln -s $(DIR)/osub.cs.prep.tok.bpe$B osub.cs.bpe$B
osub.de.clear.bpe: $(DIR)/osub.de.prep.tok.bpe$B
	ln -s $(DIR)/osub.de.prep.tok.bpe$B osub.de.bpe$B


