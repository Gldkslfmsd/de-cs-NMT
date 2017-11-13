#!/bin/bash
CP=$1
JOB=osub-europarl-morf
while [ ! -f /local/dominikm/OpenNMT/$JOB"".finished ] ; do
	cp $CP $CP""`date -u +"%Y-%m-%dT%H:%M:%SZ"`
	sleep 3600
done
