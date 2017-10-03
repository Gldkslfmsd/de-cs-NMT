#!/bin/bash

m=`ls /mnt/obo-machacek/model*_epoch*.t7 -t | head -n 1`
cp $m .
echo $m
./translate-eval.sh `basename $m`
rm `basename $m`
