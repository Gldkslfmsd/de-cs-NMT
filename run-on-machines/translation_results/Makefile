
stats:
	 grep BLEU * | sed 's/[.,]//g' | sort  -n -k 5 -r | sed 's/\(BLEU = [1-9]\?\)\([0-9]\)\([0-9][0-9]\)/\1\2.\3/' | column -t
