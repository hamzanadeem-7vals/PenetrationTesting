#!/bin/bash

file="$1";

for line in $(cat "$file");
do 
    ffuf -r -ic -recursion -recursion-depth 5 -w /usr/share/wordlists/dirb/big.txt -o $line.txt -e .rb,.sql -u https://$line/FUZZ 
done 