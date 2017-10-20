#!/bin/bash
CP=$1

while true; do
	cp $CP $CP""`date -u +"%Y-%m-%dT%H:%M:%SZ"`
	sleep 3600
done
