#!/bin/bash -x

SCRIPT_DIR="/local/mnt/workspace/pe_review/branches"
CONFIG="PL-APPROVERS.config"
SCRIPT="pe_notifier.sh"

if ! cd "$SCRIPT_DIR" ; then 
	echo "Unable to locate the directory, existing"
	exit
fi

if [ ! -f "$CONFIG" ] || [ ! -f "$SCRIPT" ] ; then
	echo "Doesn't have the either $CONFIG or SCRIPT file for compilation."
	exit
fi


for i in $(cat $CONFIG) ; do 
	PL=$(echo $i |awk -F, '{print $1}') 
	APPROVERS=$(echo $i |awk -F, '{print $1}') 
    /bin/bash -x  $SCRIPT $PL $APPROVERS 
done