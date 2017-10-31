all_jobs: eval eval-jones2
	 cat eval eval-jones2 | cut -f 2 -d" " | sed 's/_checkpoint.*//' | grep -v epoch | sed 's/model-//' | sort -u > all_jobs

prepare: all_jobs
	for i in `cat all_jobs`; do cat eval eval-jones2 | grep -v '.*_checkpoint.t7 ' | grep model-$$i | sed 's/,//' > $$i"".eval ; done

osub-figure osub_europarl_test.png: prepare
	python3 -c 'from table import *; plt.savefig("osub_europarl_test.png")' osub*.eval

europarl-figure europarl_test.png: prepare
	python3 -c 'from table import *; plt.savefig("europarl_test.png")' europarl*.eval

figs: osub_europarl_test.png europarl_test.png

score: prepare
	for i in `cat all_jobs`; do ./stats.sh < $$i"".eval| head -n 1; done | column -t
