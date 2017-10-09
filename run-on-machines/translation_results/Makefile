
stats:
	./stats.sh tr*

best:
	for i in translatio*; do 	echo ; echo $$i; ./stats.sh $$i | awk '{print $$2 "\t" $$5}' | head -n 5; done

best-files:
	for i in translatio*; do 	./stats.sh $$i | awk '{print $$2 "\t" $$5}' | head -n 5; done

THR=1500
best-files-threshold:
	for i in translatio*; do 	./stats.sh $$i |  head -n 3 | while read _ model _ _ score _ ; do if [ `echo $$score | sed 's/[.,]//g'` -gt $(THR) ]; then echo $$model; fi; done ; done

