import sys
import re
cs_file = open(sys.argv[1], "r", encoding="utf-8")
cs_out = open(sys.argv[1]+".clear", "w", encoding="utf-8")
de_out = open(sys.argv[2]+".clear", "w", encoding="utf-8")
de_file = open(sys.argv[2], "r", encoding="utf-8")

i=0
n=0
c_stack = []
d_stack = []
for c, d in zip(cs_file, de_file):
	c = c.strip()
	d = d.strip()
#	c = c.encode('utf-8').split()
#	d = d.encode('utf-8').split()
	cw = c.count(" ")
	dw = d.count(" ")
	c = re.sub("^- ?", "", c)
	d = re.sub("^- ?", "", d)


	if (cw <= 3 and dw <= 3) or abs(cw-dw) >= 16:
#		print(abs(cw-dw), c, "####", d)
		i+=1
	else:
		print(c, file=cs_out)
		print(d, file=de_out)




# concat sentences ending and beginning with -
#	if c.startswith("-"):
#		c_stack.append(c)
#		d_stack.append(d)
#	elif c.endswith("-"):
#		c_stack.append(c)
#		d_stack.append(d)
#	else:
#		if c_stack:
#			prev_c = re.sub("^- ","","".join(c_stack))
#			prev_d = re.sub("^- ","","".join(d_stack))
#			print(prev_c, "#################", prev_d)
#			c_stack = []
#			d_stack = []
#
			
##	if abs(cw-dw) > 10:
#		i+= 1
#		if i<1000:
#			print(n,c, "#######", d)
#			print(c, "###########", d)

	
#	if c.count(" ") <= 1 or d.count(" ") <= 1:
	n+=1
#
# TODO: pospojovat ty přes -
# vymazat jednoslovné věty
# spojit s europarlem
# => trénovat

#print(i, n, i/n)
cs_file.close()
de_file.close()
cs_out.close()
de_out.close()
