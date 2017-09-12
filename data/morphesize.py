from polyglot.text import Word

import sys

LANGUAGE = sys.argv[1]

for line in sys.stdin:
	l = []
	for w in line.split():
		m = Word(w, language=LANGUAGE).morphemes
		if len(m) == 1:
			l.append(w)
		else:
			l.append("@@ ".join(m))
	print(" ".join(l))

