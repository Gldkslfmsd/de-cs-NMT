
import sys
from langdetect import *

# for reproducible results
DetectorFactory.seed = 0

cs_in = open(sys.argv[1], "r")
de_in = open(sys.argv[2], "r")

cs_out = open(sys.argv[3], "w")
de_out = open(sys.argv[4], "w")

log = open("clean_log", "w")

i = 1
for c, d in zip(cs_in, de_in):
	control = False
	# according to our observation on first 10000 sentences, this covers
	# most errors:
	for w in ["Abstimmung ", "Sitzung ", "Empfehlung "]:
		if w in d:
			control = True
			break
	if "Bericht " in d:
		if not "Zpráv" in c and not "práv" in c:
			control = True
	if d[0] == "-": 
		if not "Zpráv" in c and not "práv" in c:
			control = True
	if c == d: control = True
#	print(i, c, d)
	try:
		if control == True and detect(c) != 'cs':
			print(i, detect_langs(c), "\n", c, d)
			print(i, detect_langs(c), "\n", c, d, file=log)
		else:
			det = detect_langs(c)[0]
			if det.prob > 0.9 and det.lang in ["en", "es", "fr", "pl"]:
				print(i, detect_langs(c), "\n", c, d)
				print(i, detect_langs(c), "\n", c, d, file=log)
			else:
				print(c, file=cs_out, end="")
				print(d, file=de_out, end="")
	except lang_detect_exception.LangDetectException:
		print(i, c, d)
		print(i, c, d, file=log)
	i += 1

cs_in.close()
de_in.close()
cs_out.close()
de_out.close()

