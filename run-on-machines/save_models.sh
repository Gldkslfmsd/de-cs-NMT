DIR=models
plan=save_plan
: > $plan
paralel="&"
cat csen-machines | while read user ip port; do
	echo echo ssh -l $user $ip $port >>  $plan	;
	cat $1 | while read m; do
		echo		rsync -t --rsh=\"ssh -l $user $port\" $ip:$m $DIR \|\| echo chyba!!! $us $ip $port $par >> $plan $paralel
	done
done
echo echo azure2 >> $plan	
	cat $1 | while read m; do
	echo		rsync -t azure2:$m  $DIR \|\| echo chyba!!! azure2 >> $plan $paralel
	done

echo wait >> $plan

bash $plan
