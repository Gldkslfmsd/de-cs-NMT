#!/usr/bin/python3
import sys

ref = sys.argv[1]
mt = sys.argv[2]

import random

random.seed(1)

with open(ref, "r") as g:
	with open(mt, "r") as h:
		sentences = list(zip(g.readlines(), h.readlines()))

random.shuffle(sentences)

for i in range(100):
	with open("tmp/%s.%d" % (ref, i), "w") as f:
		print(sentences[i][0], end="", file=f)
	with open("tmp/%s.%d" % (mt, i), "w") as g:
		print(sentences[i][1], end="", file=g)
			
print("\n".join("\t".join(a.strip() for a in s) for s in sentences[:100]))
			
			
