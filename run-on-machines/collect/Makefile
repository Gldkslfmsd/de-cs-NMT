MAX=10

unfinished unf:
	: > unfinished
	for i in `seq 1 $(MAX)`; do \
		if [ ! -f $$i"".log ] || ! grep 'perplexity' $$i"".log >/dev/null || grep '999999999999999999' $$i"".log > /dev/null ; then \
			echo $$i >> unfinished ; \
		fi; \
	done;
	cat unfinished

waiting wait:
	: > waiting
	for i in `seq 1 $(MAX)`; do \
		if [ ! -f $$i"".log ] ; then \
			echo $$i >> waiting ; \
		fi; \
	done;
	cat waiting

results: unfinished
	grep -n -m 1 "perplexity:" *.log  | sed 's/\./ /;s/ .* / /' > results
	for i in `cat unfinished`; do echo $$i 999999999999999999 >> results; done
	cp results tmp
	sort -n -k 1 tmp > results

SAME=th train.lua .* -max_batch_size 1
SAME2=-log_file.*$
n_params:
	cat ../params | sed 's/:/ /;s/$(SAME)//;s/$(SAME2)//'  > n_params

results_params.txt join: results n_params
	paste results n_params | sort -n -k 2 | column -t > results_params.txt
	cp results_params.txt join

uni: join
	sed -e 's/ /_/g;s/^\([0-9]\+\)_*/\1 /' join | sort -u -k 2 | sed 's/_/ /g' | sort -k 2 -n | column -t > uni
	cp uni results_params.txt

