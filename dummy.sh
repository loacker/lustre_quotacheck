#!/bin/bash

usage() {
	cat << __EOF__
Execute the lfs command specifing in an environment variable the type of test:
TEST=[soft|hard|veryhard] lfs quota -qg <group> <file system>

e.g. TEST=soft lfs quota -qg matteo /home

__EOF__
}

( [[ -z "$TEST" ]] || [[ -z "$4" ]] ) && usage

filesystem=$4

if [ "$TEST" == "soft" ]
then
        echo "${filesystem}   10232   10240   20480       -      24*      5      10       -"
elif [ "$TEST" == "hard" ]
then
	echo "${filesystem}   20532*  10240   20480       -      34*      5      10       -"
elif [ "$TEST" == "veryhard" ]
then
	echo "${filesystem}   30772*  10240   20480       -      44*      5      10       -"
fi
