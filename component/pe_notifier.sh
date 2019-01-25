SCRIPT_DIR="/local/mnt/workspace/pe_review/branches"
PL="$1"
APPROVERS="$2"
GSERVER="review-android.quicinc.com"
TMP_FILE="`mktemp`"
trap "rm -rf $TMP_FILE" EXIT INT
cat > $SCRIPT_DIR/$PL.html << EOJ
Updates every 45mins.. Last updated: <b>`date`</b>
EOJ
cat >> $SCRIPT_DIR/$PL.html << EOJ
<table border="2" align=center WIDTH="20%" CELLPADDING="4" CELLSPACING="1" style="background-color:cyan">
<tr>
<td width="50" align=center><b>$PL</b></td>
</tr>
EOJ

cat >> $SCRIPT_DIR/$PL.html << EOJ
<br><br>
<table border="2" align=center WIDTH="50%" CELLPADDING="4" CELLSPACING="3" style="background-color:cyan">
<tr>
        <td width="50" align=center><b>Change number</b></td>
        <td width="50" align=center><b>Project</b></td>
        <td width="50" align=center><b>Branch</b></td>
        <td width="50" align=center><b>Subject</b></td>
</tr>
EOJ

ssh -p 29418 $GSERVER gerrit query status:open AND pl:${PL} AND label:"Code-Review>=+1" AND NOT label:"Code-Review<=-1" AND NOT label:"Code-Review>=+1,group=ldap/${APPROVERS}" AND label:"Developer-Verified=+1" AND NOT label:"Developer-Verified=-1" AND label:"Verified=+1" AND NOT label:"Verified=-1" --format=JSON | grep -v rowCount > $TMP_FILE

CHANGES="`cat $TMP_FILE | jq .number |xargs`"
for change in $CHANGES
do
    PROJECT=`cat $TMP_FILE | jq ". | select(.number==\"${change}\") | .project"|xargs`
    BRANCH=`cat $TMP_FILE | jq ". | select(.number==\"${change}\") | .branch"|xargs`
    SUBJECT=`cat $TMP_FILE | jq ". | select(.number==\"${change}\") | .subject"|xargs`

cat >> $SCRIPT_DIR/$PL.html << EOJ
<tr>
        <td width="50" align=center><a href="https://review-android.quicinc.com/$change">$change</a></td>
        <td width="50" align=center>$PROJECT</td>
        <td width="50" align=center>$BRANCH</td>
        <td width="50" align=center><pre>$SUBJECT</pre></td>
</tr>
EOJ

done
chmod 644 $SCRIPT_DIR/$PL.html
