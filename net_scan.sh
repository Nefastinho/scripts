#!/bin/bash
# ****** IMPORTANT: Run this script as sudo ******

# First, we get all the active connections with nmap
# Second, we filter them with the pattern MAC Address, and get the third column (the MAC itself, using space as separator)
# Third, we replace each newline with '|'
#	1. Create a label via :a.
#	2. Append the current and next line to the pattern space via N.
#	3. If we are before the last line, branch to the created label $!ba ($! means not to do it on the last line as there should be one final newline).
#	4. Finally the substitution replaces every newline with a '|' on the pattern space (which is the whole file).

#MACS_PARSED=$(sudo nmap -sn 192.168.1.0/24 | awk '/MAC Address:/{ print $3 }' | sed ':a;N;$!ba;s/\n/|/g')

# Runs an OS detection scan of the UNKOWN_IP array
analyse_ip () {	
	UNKNOWN_IP=$1	
	for IP in $UNKNOWN_IP; do
		echo "$IP:"
		echo '---------------------------------'
		sudo nmap -sV -O -v $IP
		echo '---------------------------------'
	done
}

MACS_FILE=$1
WARNING_FILE=$2
IP_FILE=$3

NMAP_RESULT=$(nmap -sn 192.168.1.0/24)

RAW_MACS=$(echo $NMAP_RESULT | grep -oE '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
RAW_IPS=$(echo $NMAP_RESULT | grep -oE "([0-9]{1,3}\.){3}[0-9]{1,3}")
# There will always be one more IP than the number of MAC addresses, because localhost shows its IP address but not its MAC
MACS_PARSED=$(echo $RAW_MACS | sed 's/ /|/g')	# We replace spaces with '|' in order to use an unique string in grep
IPS_ARRAY=($RAW_IPS) # Converting IPs string into an array

echo '---------------------------------'
echo 'Known hosts:'
echo '---------------------------------'
grep -iE $MACS_PARSED $MACS_FILE

echo '---------------------------------'
echo 'Unknown hosts:'
echo '---------------------------------'

# If the mac address is not in the MACS_FILE, then it's not recognized
INDEX=0
DATE=$(date '+%d/%m/%Y %T')
UNKNOWN_IP=()	#Array which contains the IPs associated with the MACs we don't recognize

# We compare if the MACs detected are inside the MACS_FILE
for MAC in $RAW_MACS; do
    if ! grep -q $MAC $MACS_FILE
	then
    	echo "[$DATE] $MAC - ${IPS_ARRAY[$INDEX]} is not recognized" | tee -a $WARNING_FILE	# We echo to standard output and to a file with tee
		UNKNOWN_IP+=(${IPS_ARRAY[$INDEX]})
	fi
	((INDEX++))
done

# If UNKNOWN_IP is not empty, we analyse the IPs detected
if ! [ -z "$UNKNOWN_IP" ]
	then		
		echo '---------------------------------'
		echo "Analizing IPs detected..."
    	analyse_ip "$UNKNOWN_IP" >> $IP_FILE	
		echo "Done"
fi