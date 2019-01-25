cleanup_location=$1

echo "Cleaning up requests"
find $cleanup_location -iname "*.txt" -mmin +5 -exec rm -f {} \;
find $cleanup_location -iname "*.json" -mmin +5 -exec rm -f {} \;
find $cleanup_location -iname "*.html" -mmin +5 -exec rm -f {} \;
