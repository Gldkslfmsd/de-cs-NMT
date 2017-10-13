
import sys
lines = open(sys.argv[1], "r").readlines()
parts = int(sys.argv[2])
prefix = sys.argv[3]

n = len(lines)

chunk_size = n // parts
residual = n % parts

j = 0
for p in range(parts):
	with open("%s%d" % (prefix, p), "w") as f:
		for _ in range(chunk_size):
			print(lines[j], end="", file=f)
			j += 1
		if residual > 0:
			print(lines[j], end="", file=f)
			j += 1
			residual -= 1
