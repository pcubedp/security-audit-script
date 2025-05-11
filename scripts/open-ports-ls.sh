#!/bin/bash

#take input from ss-tulnp, loop for each line, awk the needed part for each line into a varaible
# -z is a string test that returns true if string is of zero length, tail -n +2 to skip header line
# so we are checking the line variable, if its empty we do && continue, && is AND operator which will only run if first argument is true, in this case its true if variable is empty.


echo "---------OPEN PORTS & LISTENING SERVICES AUDIT-------------"

ss -tulnp | tail -n +2| while read -r line; do
    
    [[ -z "$line" ]] && continue

    protocol=$(echo $line | awk '{print $1}')
    local_address=$(echo $line | awk '{print $5}')
    peer_address=$(echo $line | awk '{print $6}')
    process=$(echo $line| awk '{for(i=7; i<=NF; ++i) printf $i " "; print ""}')

    [[ -z "$process" ]] && process="N/A"
   

    echo "Protocol      : $protocol"
    echo "Local Address : $local_address"
    echo "Peer Address  : $peer_address"
    echo "Process Info  : $process"
    echo "-------------------------------------------------------"
done

   
