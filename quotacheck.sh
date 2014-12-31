#!/bin/bash

# command: quotacheck.sh
# description: Check the lustre group quota and send an email
#              just in case of exceeding the threshold.
# test: Test copying the dummy.sh script in the same path as
#       the quotacheck.sh script and set the variable TEST with 
#       the value soft, hard or veryhard.


VERSION=0.4
FILESYSTEM="/home"
DEBUG=1
PATH=$PATH:/usr/bin


if [[ -n $TEST ]]
then
        shopt -s expand_aliases
        alias lfs="`pwd`/dummy.sh"
fi


command() {
        lfs quota -qg ${group} ${FILESYSTEM}
}


msg() {
        cat <<__EOF__
Caro ${name} ${surname},

volevo avvisarla che ha superato il limite di quota impostato per il suo gruppo
sul filesystem lustre ${FILESYSTEM}.
La prego di provvedere al piu' presto rientrando nei valori di quota definiti.

Buona giornata.

Il suo script.

Attualmente sta occupando ${number_of_files%\*} kilobytes.

I suoi limiti per il numero di file sono:
    Hard limit: ${hard_limit}
    Soft limit: ${soft_limit} 

__EOF__
}


sendmail() {
        msg | mail -s "Lustre quota exeeding" ${email}
}


usage() {
        cat <<__EOF__
Usage:
   quotachek.sh <-t|--threshold> <-e|--email> <group>

Options:
    -t|--threshold     Threshold to monitor (Percentage value e.g. 80%)
    -e|--email         Email address to notify 

Argument:
    group              Group to check 

__EOF__
}


while [ ${#} -gt 0 ]
do
        arg=${1}
        shift
        case "${arg}" in
                -t|--threshold)
                        threshold=${1%\%}
                        shift
                        ;;
                -e|--email)
                        email=${1}
                        shift
                        ;;
                -h|--help)
                        usage
                        exit 0
                        ;;
                -v|--version)
                        echo "${VERSION}"
                        exit 0
                        ;;
                -*)
                        usage "You have specified an invalid option: ${arg}"
                        exit 1
                        ;;
                *)
                        group=${arg}
         esac
done


if [ -z "${group}" -o -z "${email}" -o -z "${threshold}" ]
then
        usage
        exit 0
fi


if [ ${DEBUG} == "1" ]
then
        set -x
fi


declare -a userdata=(`finger $USER`)
declare -a quota=(`command`)
name=${userdata[3]}
surname=${userdata[4]}
number_of_files=${quota[1]}
soft_limit=${quota[2]}
hard_limit=${quota[3]}
grace=${quota[4]}
number_of_inode=${quota[5]}
soft_limit_inode=${quota[6]}
hard_limit_inode=${quota[7]}
grace_inode=${quota[8]}
hard_limit_threshold=$(( ${hard_limit}*${threshold}/100 ))


# Send an email if the exeeding the threshold
if [ "${number_of_files%\*}" -gt "${hard_limit_threshold}" ]
then
        sendmail
fi


# vim: set ts=8 sw=8 sts=0 tw=0 ff=unix ft=sh et ai :
