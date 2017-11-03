#!/usr/bin/python3
import sys
src = sys.argv[1]
ref = sys.argv[2]
mt = sys.argv[3]
base = sys.argv[4]
google = sys.argv[5]

import random

random.seed(1)

with open(src, "r") as srcf:
	with open(ref, "r") as reff:
		with open(mt, "r") as mtf:
			with open(base, "r") as basef:
 				with open(google, "r") as googf:		                   
                                    sentences = list(zip(srcf.readlines(), reff.readlines(), basef.readlines(), googf.readlines(), mtf.readlines())) 
random.shuffle(sentences)

for i in range(100):
	print("SRC\t%sREF\t%sZEM\t%sGT\t%sMT\t%sNOTE:\t\n" % sentences[i])
			
			
