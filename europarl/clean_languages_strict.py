
# Filters all sentences, which langdetect library detects as non-cs and
# non-de.
# This seems to filter too many correct sentences, the library is not
# optimal, therefore we don't use this script.

import sys
from langdetect import *

cs_in = open(sys.argv[1], "r")
de_in = open(sys.argv[2], "r")

cs_out = open(sys.argv[1]+".cleaned", "w")
de_out = open(sys.argv[2]+".cleaned", "w")

i = 1
for c, d in zip(cs_in, de_in):
#	print(i, c, d)
	try:
		if detect(c) != 'cs' or detect(d) != 'de':
			print(i, c, d)
		else:
			print(c, file=cs_out, end="")
			print(d, file=de_out, end="")
	except lang_detect_exception.LangDetectException:
		print(i, c, d)
	i += 1

cs_in.close()
de_in.close()
cs_out.close()
de_out.close()

