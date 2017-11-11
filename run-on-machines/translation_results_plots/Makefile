all_jobs: 
	 cat translati* | cut -f 2 -d" " | sed 's/_checkpoint.*//' | grep -v epoch | sed 's@.*/@@' | sort -u > all_jobs

prepare: all_jobs
	for i in `cat all_jobs`; do cat translati* | grep $$i | grep BLEU | sed 's/,//' | grep -v 100 > $$i"".eval ; done

all_models: prepare
	python3 -c 'from table import *; ' model*.eval
#plt.savefig("all_models.png")

models-2: prepare
	python3 -c 'from table import *; ' model?.eval
#plt.savefig("all_models.png")



best_models: prepare
	python3 -c 'from table import *;' model11-oboma136d000006* model13-oboma136d000009* model14-obomab1dd00000F* model15-obomab1dd00000G* model17-obomab1dd00000J* model19-oboma136d000002* model20-oboma136d000003* model21-oboma136d000004* model9*

figs: osub_europarl_test.png europarl_test.png

score: prepare
	for i in `cat all_jobs`; do ./stats.sh < $$i"".eval| head -n 1; done | column -t
