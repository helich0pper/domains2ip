#!/bin/bash
# Color codes
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'

printf "${BLUE}"
# Banner
printf '                   __\n'
printf ' _| _  _  _ . _  _  _). _\n'
printf '(_|(_)|||(_||| )_) /__||_) \n'
printf '                       |\n'
printf "domains2ip \n\tby helich0pper\n\thttps://github.com/helich0pper\n\n${NC}"

# Help
Help () {
	printf "\nUsage\n./domains2ip [OPTIONS]\n\n"
	printf "Options:\n\t-h Help menu\n\t-t <number> Timeout in seconds (default is 5 seconds)"
	printf "\n\t-f <file> Input file containing domain names\n\t-o <file> Output to file\n\n"
}

# Variables
INFILE=""
TIMEOUT=5
OUTFILE=""

# Functions
GetIP () {
	printf "%-30s %-30s" "$1"
	ret=$(timeout $2 dig $1 +short)
	if [[ $ret = "" || ! $? -eq 0 ]]
	then
			printf "${RED}Could not resolve!${NC}"
	else
		printf ${GREEN}$ret${NC}
	fi
}

GetIPReport () {
	printf "%-30s %-30s" "$1"
	ret=$(timeout $2 dig $1 +short +tries=1)
	if [[ $ret = "" || ! $? -eq 0 ]]
	then
			printf "${RED}Could not resolve!${NC}"
	else
		printf ${GREEN}$ret${NC}
		printf "${1}:${ret}\n" >> $3
	fi
}
# Main
## Arguments
while getopts "t:o:f:" options; do
    case "$options" in
    t)  TIMEOUT="${OPTARG}"
        ;;
		f)  INFILE="${OPTARG}"
		    ;;
		o)  OUTFILE="${OPTARG}"
		    ;;
    esac
done

## Verify
if [[ $# -eq 0 ]]
	then
		Help
		exit 0
fi
if [[ -z $INFILE ]]
  then
    printf "${RED}[-] File not specified!${NC}\n"
    Help
    exit 0
fi
if [[ ! -f $INFILE ]]
  then
		printf "${RED}[-] File not found!${NC}\n"
    exit 0
fi

# Start
printf "${GREEN}[+] Starting...\n[+] Timeout: ${TIMEOUT}s\n${NC}"

if [[ $TIMEOUT -lt 5 ]]
	then
		printf "${YELLOW}[!] Note: Increase timeout for more reliable results\n\n${NC}"
fi
if [[ -z $OUTFILE ]]
	then
		while read i
		do
			GetIP $i $TIMEOUT $TRIES
			printf "\n"
		done < $INFILE
else
	while read i
	do
		GetIPReport $i $TIMEOUT $TRIES $OUTFILE
		printf "\n"
	done < $INFILE
fi
# Done
printf "\nDone\n";
