#!/usr/bin/python3
import sys

documents = []
for fn in sys.argv[1:-1]:
	with open(fn, "r") as f:
		documents.append(f.readlines())

notes = open(sys.argv[-1], "r").readlines()

sentences = list(zip(*documents))

import random

random.seed(1)

random.shuffle(sentences)


form = "SRC\t%sREF\t%sZEM\t%sGT\t%sCUD\t%sMT\t%sNOTE:\t%s\n"
#s = sys.stdin.readline()
#while s:
#	form = s
#	s = sys.stdin.readline()
#

for i in range(100):
#	s = *sentences[i], notes[i]
	print(form % tuple(list(sentences[i]) + [notes[i]]), end="")#notes[i]))


