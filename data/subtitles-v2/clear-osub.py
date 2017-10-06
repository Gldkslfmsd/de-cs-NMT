cs_file = open("osub.cs.prep.tok", "r", encoding="utf-8")
de_file = open("osub.de.prep.tok", "r", encoding="utf-8")

i=0
n=0
for c, d in zip(cs_file, de_file):
	c = c.strip()
	d = d.strip()
#	c = c.encode('utf-8').split()
#	d = d.encode('utf-8').split()
#	if c.count(" ") <= 1 or d.count(" ") <= 1:
	cw = c.count(" ")
	dw = d.count(" ")
	if abs(cw-dw) > 10:
		i+= 1
		if i<50:
			print(c, "###########", d)
	n+=1

# TODO: pospojovat ty přes -
# vymazat jednoslovné věty
# spojit s europarlem
# => trénovat

print(i, n, i/n)
cs_file.close()
de_file.close()
