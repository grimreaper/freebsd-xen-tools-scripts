#!/bin/sh

interfaces=$(/sbin/ifconfig | grep '<UP,' | grep ': flags=' | grep -v 'plip' | grep -v 'ipfw' | grep -v 'lo0' | cut -d ':' -f1)


for if in $interfaces ; do

echo `echo $if | sed 's/xn/eth/g'` "|" `/sbin/ifconfig $if | grep 'inet ' | cut -d ' ' -f2`

done
