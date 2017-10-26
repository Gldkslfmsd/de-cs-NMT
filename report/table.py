
import sys
from datetime import datetime

import matplotlib.pyplot as plt

def to_date(t):
    date = datetime.strptime(t, '%Y-%m-%d_%H:%M:%S')
    return date

times = []
bleus = []
time, _, _, _,  bleu, *_ = sys.stdin.readline().split()
time = to_date(time)
#times.append(time-time)
#bleus.append(float(bleu))

for line in sys.stdin:
    t, _, _, _,  b, *_ = line.split()
    times.append((to_date(t)-time).total_seconds())
    bleus.append(float(b))

for t,b in zip(times, bleus):
    print(t,b)



# plot
plt.scatter(times, bleus)
# beautify the x-labels
plt.gcf().autofmt_xdate()

plt.show()
