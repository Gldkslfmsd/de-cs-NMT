
missing miss:
	: > missing
	for i in `seq 1 121`; do \
		if [ ! -f $$i"".log ] || ! grep 'perplexity' $$i"".log >/dev/null || grep '999999999999999999' $$i"".log > /dev/null ; then \
			echo $$i >> missing ; \
		fi; \
	done;
	cat missing

results: missing
	grep -n -m 1 "perplexity:" *.log  | sed 's/\./ /;s/ .* / /' > results
	for i in `cat missing`; do echo $$i 999999999999999999 >> results; done
	cp results tmp
	sort -n -k 1 tmp > results

params: 
	./gen-parameters.sh > params

SAME=th train.lua .* -save_every 500
SAME2=-log_file.*$
n_params: params
	cat params | sed 's/:/ /;s/$(SAME)//;s/$(SAME2)//'  > n_params

join: results n_params
	paste results n_params | sort -n -k 2 | column -t > join

results_params.txt uni: join
	sed 's/^[^ ]* *//' join | sort -u | sort -n -k 1 > results_params.txt 

