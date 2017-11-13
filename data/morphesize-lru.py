from polyglot.text import Word

import sys
import functools

@functools.lru_cache(maxsize=None)
def morf(w):
	return Word(w, language=LANGUAGE).morphemes

LANGUAGE = sys.argv[1]

for line in sys.stdin:
	l = []
	for w in line.split():
		m = morf(w)
		if len(m) == 1:
			l.append(w)
		else:
			l.append("@@ ".join(m))
	print(" ".join(l))

