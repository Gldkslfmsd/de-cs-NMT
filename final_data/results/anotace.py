#!/usr/bin/python3
import sys
src = sys.argv[1]
ref = sys.argv[2]
mt = sys.argv[3]
base = sys.argv[4]

import random

random.seed(1)

with open(src, "r") as f:
	with open(ref, "r") as g:
		with open(mt, "r") as h:
			with open(base, "r") as ch:
				sentences = list(zip(f.readlines(), g.readlines(), ch.readlines(), h.readlines()))

random.shuffle(sentences)

for i in range(100):
	print("SRC\t%sREF\t%sZEM\t%sMT\t%sNOTE:\t\n" % sentences[i])
			
			
