
import sys

# size of A > size of B
A = open(sys.argv[1], "r")
B = open(sys.argv[2], "r")

b = set(B.readlines())
for a in A:
	if a in b:
		print(a)
