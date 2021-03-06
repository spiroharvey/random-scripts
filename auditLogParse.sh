#!/bin/bash
#
# by Spiro Harvey <spiro.harvey@protonmail.com>
# Released under GPLv3
# Date: Jun 2021
#
# Description: Parses and displays audit.log events
# Usage: auditLogParse.sh < /var/log/audit/audit.log | most
#

# Colours
# taken from: https://unix.stackexchange.com/questions/124407/what-color-codes-can-i-use-in-my-ps1-prompt
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
bakgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset


while read line
do
	recType=""
	recAcct=""
	recExe=""
	recHost=""
	recAddr=""
	timestamp=""
	for word in $line; do
		if [[ "$word" == msg=audit* ]]; then
			dt=${word##*(}
			dt=${dt%%.*}
			timestamp=$(date --date="@$dt" +"%F %R:%S")
		fi
		[[ "$word" == type* ]] && recType=${word##*=}
		[[ "$word" == acct* ]] && recAcct=$(echo ${word##*=}| tr -d \")
		[[ "$word" == exe=* ]] && recExe=$(echo ${word##*=} | tr -d \")
		[[ "$word" == ?hostname=* ]] && \
								recHost=$(echo ${word##*=} | tr -d ,)
		[[ "$word" == addr=* ]] && \
								recAddr=$(echo ${word##*=} | tr -d ,)
	done
	printf "$txtwht${timestamp} [$bldylw${recType}$txtwht]\t$bldwht${recAcct}\t"
	printf "$txtwht($txtblu${recExe}$txtwht) $txtcyn${recHost} ${recAddr}$txtrst\n"
done

