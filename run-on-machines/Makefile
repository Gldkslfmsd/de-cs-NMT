
#IPS=10ips-dm
#IPS=new-machines
IPS=new14

yes-machines:
	cat $(IPS) | while read line; do \
		echo $$line; \
		echo hostname | ssh -l $$line ; \
	done

.ONESHELL:
install-on-machines:
	cat $(IPS) | while read us ip port ; do \
		echo $$us $$ip $$port; \
		echo sudo /share/obo-machacek/prepare-machine.sh | ssh $$us@$$ip $$port & \
	done; wait
	


.ONESHELL:
use-mnt-on-machines:
	cat $(IPS) | while read user ipport; do \
		echo sudo chown $$user /mnt | ssh -l $$user $$ipport  > /dev/null || echo $$ipport &  \
	done; wait

QS="th preprocess.lua -train_src data/src-train.txt -train_tgt data/tgt-train.txt -valid_src data/src-val.txt -valid_tgt data/tgt-val.txt -save_data data/demo"

#.ONESHELL:
#launch-on-machines:
#	cat 30ips | while read us ip; do \
#		echo $$us $$ip; \
#		echo for s in \`find .\`\; do sudo chown $$us $$s\; done | ssh $$us@$$ip && echo $$us $$ip >> ok || echo ko $$us $$ip >> ok & \
#	done
#	wait
#	cat ok
#|| echo $$us $$ip

ITER=6

missing_params: gen-parameters$(ITER).sh collect/missing
	./gen-parameters$(ITER).sh > params
	grep . -n params > p
	: > para ;cat collect/missing | while read line; do grep "^$$line"":" p >> para ; done
	sed 's/^[^:]*://' para > params
	python3 split.py params `wc -l $(IPS) | cut -f 1 -d" "` params-
#	tail -1 params >> params-ap


#gen_parameters$(ITER).sh collect/waiting
wait_params: 
	./gen-parameters$(ITER).sh > params
	grep . -n params > p
	: > para ;cat collect/waiting | while read line; do grep "^$$line"":" p >> para ; done
	sed 's/^[^:]*://' para > params
	python3 split.py params `wc -l $(IPS) | cut -f 1 -d" "` params-


params: gen-parameters$(ITER).sh
	bash gen-parameters$(ITER).sh > params
	rm -rf params-*
	python3 split.py params `wc -l $(IPS) | cut -f 1 -d" "` params-
#	tail -1 params >> params-ap





# copy also install-onmt.sh  ???
copy-params:
	ls params-* > p
	paste p $(IPS) > ip_p
	: > plan
	cat ip_p | while read par user ip port; do \
echo	echo	rsync --rsh=\"ssh -l $$user $$port\" launch-script.sh $$ip:~/ \|\| echo chyba!!! $$us $$ip $$port $$par \& >> plan ; \
echo		rsync --rsh=\"ssh -l $$user $$port\" launch-script.sh $$ip:~/ \|\| echo chyba!!! $$us $$ip $$port $$par \& >> plan ; \
echo	echo	rsync --rsh=\"ssh -l $$user $$port\" $$par $$ip:~/par \|\| echo chyba!!! $$us $$ip $$port $$par \& >> plan ; \
echo		rsync --rsh=\"ssh -l $$user $$port\" $$par $$ip:~/par \|\| echo chyba!!! $$us $$ip $$port $$par \& >> plan ; \
	done
	echo wait >> plan
#	bash plan


#.ONESHELL:
#launch-training-on-machines:
#	cat 10ips | while read ip; do \
#		echo $$ip; \
#		echo bash launch-script.sh < par | ssh obo-machacek@$$ip & \
#	done; wait
#
.ONESHELL:
collect-new-logs:
	: > plan
	cat $(IPS) | while read user ip port; do \
	echo echo ssh -l $$user $$ip $$port >> plan	;	\
echo		rsync --rsh=\"ssh -l $$user $$port\" $$ip:~/*.log $$ip:~/*.out $$ip:~/*.err collect-$(IPS)/ \|\| echo chyba!!! $$us $$ip $$port $$par >> plan \& ; \
	done
	echo wait >> plan
#	bash plan


.ONESHELL:
collect-logs-de:
	: > plan
	cat 5ips-de | while read user ip port; do \
	echo echo ssh -l $$user $$ip $$port >> plan	;	\
echo		rsync --rsh=\"ssh -l $$user $$port\" $$ip:~/*.log $$ip:~/*.out $$ip:~/*.err collect-de/ \|\| echo chyba!!! $$us $$ip $$port $$par >> plan \& ; \
	done
	echo wait >> plan

.ONESHELL:
collect-logs:
	: > plan
	cat 10ips-dm | while read user ip port; do \
	echo echo ssh -l $$user $$ip $$port >> plan	;	\
echo		rsync --rsh=\"ssh -l $$user $$port\" $$ip:~/*.log $$ip:~/*.out $$ip:~/*.err collect/ \|\| echo chyba!!! $$us $$ip $$port $$par >> plan \& ; \
	done
	echo wait >> plan
#	bash plan

.ONESHELL:
collect-tr-res:
	: > plan
	cat csen-machines | while read user ip port; do \
	echo echo ssh -l $$user $$ip $$port >> plan	;	\
echo		rsync --rsh=\"ssh -l $$user $$port\" $$ip:/mnt/translation_* translation_results/ \|\| echo chyba!!! $$us $$ip $$port $$par >> plan \& ; \
	done
	echo echo azure2 >> plan	;	\
	echo		rsync azure2:/mnt/csen-data/mini/translation_* translation_results/ \|\| echo chyba!!! $$us $$ip $$port $$par >> plan \& ; \
	echo wait >> plan
#	bash plan






