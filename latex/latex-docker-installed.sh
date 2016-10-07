#!/bin/sh
num=`docker images | grep -i -c 'blang/latex\s'`
#echo $num 
if [ "$num" -gt "0" ]; then exit 0; else exit 1; fi
