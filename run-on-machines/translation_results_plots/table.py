
import sys
from datetime import datetime

import matplotlib.patches as mpatches
import matplotlib.pyplot as plt

def to_date(t):
    date = datetime.strptime(t, '%Y-%m-%d_%H:%M:%S')
    return date

def plot_from_file(filename):
	times = []
	bleus = []

	with open(filename, "r") as f:
		lines = [ l.split() for l in sorted(f.readlines()) ]
		time, _, _, _,  bleu, *_ = lines[0]
		time = to_date(time)
		print(time, bleu)
#		times.append(0)
#		bleus.append(float(bleu))
#
		for line in lines:
			t, _, _, _,  b, *_ = line
			times.append((to_date(t)-time).total_seconds() // 3600 )
			bleus.append(float(b))

	return times, bleus
#
#		for t,b in zip(times, bleus):
#			print(t,b)
#
#

# plot

fig = plt.figure()
ax = plt.subplot(111)
for a in sys.argv[1:]:
	times, bleus = plot_from_file(a)
	plt.scatter(times, bleus)
	ax.plot(times, bleus, label=a)

box = ax.get_position()
ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))

#legend = ax.legend(loc='upper right', shadow=True)
#if sys.argv[1].startswith("osub"):
#	legend = ax.legend(loc='lower right', shadow=True)
#	pass
#else:
##	legend = ax.legend(loc='upper right', shadow=True)
#    pass
#frame = legend.get_frame()
#frame.set_facecolor('0.90')



## beautify the x-labels
#plt.gcf().autofmt_xdate()

plt.xlabel("Hours")
plt.ylabel("test BLEU")

#
plt.show()
#plt.savefig("europarl_test.png")
#plt.savefig("osub_europarl_test.png")
