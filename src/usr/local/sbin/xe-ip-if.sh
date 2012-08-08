#!/bin/sh

interfaces=$(/sbin/ifconfig -u | grep ': flags=' | grep -Ev '(plip|ipfw|lo0)' | cut -d ':' -f1)


for if in $interfaces ; do

echo `echo $if | sed 's/xn/eth/g'` "|" `/sbin/ifconfig $if | grep 'inet ' | cut -d ' ' -f2`

done
