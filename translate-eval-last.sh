#!/bin/bash

./translate-eval.sh `ls $1/model*.pt -t | head -n 1`
