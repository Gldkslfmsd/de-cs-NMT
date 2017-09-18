
missing miss:
	: > missing
	for i in `seq 1 120`; do \
		if [ ! -f $$i"".log ] || ! grep 'perplexity' $$i"".log >/dev/null || grep '999999999999999999' $$i"".log > /dev/null ; then \
			echo $$i >> missing ; \
#			echo perplexity: 999999999999999999 > $$i"".log ; \
		fi; \
	done;
	cat missing

results:
	grep -n -m 1 "perplexity:" *.log  | sed 's/\./ /;s/ .* / /' | sort -k 1 -n >  results

SAME=th train.lua .* -save_every 5000
SAME2=-log_file.*$
n_params:
	cat ../params | sed 's/:/ /;s/$(SAME)//;s/$(SAME2)//' | sort -n -k 1 > n_params

join: results n_params
	paste results n_params | sort -n -k 2 | column -t > join

uni: join
	sed 's/^[^ ]* *//' join | sort -u | sort -n -k 1 > uni

