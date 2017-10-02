
cd /mnt

i=1

while [ $i -lt 10 ]; do
	CP=`ls -t *checkpoint* | head -n 1`

	cp $CP $CP""`date -u +"%Y-%m-%dT%H:%M:%SZ"`
	sleep 10
	i=$(($i+1))
done

