#!/bin/bash
	grep BLEU $@ > all
	cut -f 5 -d" " all | sed 's/[.,]//g' > keys
	paste keys all | sort  -n -k 1 -r | sed 's/^.*\t//' | column -t 
