#!/usr/bin/env bash
# 
# Name        : format-affected-hosts.sh 
# Description : This script will take a user supplied list of IP addresses
#               sort and extract the unique IPs then format them into a 
#               HTML table with the user specified column number.
#               The results are output to the console for easy copy/paste
#               into a pentest report as affected hosts.
# Version     : 1.0
# Author      : Greg Nimmo

# a few global variables for ease of use
filename=$1
columns=$2

# format a column width based on the column count
colwidth=""
case "$2" in
    1) colwidth='<col width="100%">'
        ;;
    2) colwidth='<col width="50%">'
        ;;
    3) colwidth='<col width="33%">'
        ;;
    4) colwidth='<col width="25%">'
        ;;
        # create 100% for unspecified column count as default is one column
    *) colwidth='<col width="100%">'
        ;;
esac


# script usage function
Help() {
    echo "[*] Usage : $0 [filename] <column>"
    echo ""
    echo "[*] [filename] - manadatory : name of a file containing a list of IP addresses (one per line)"
    echo "[*] <column> - optional : number of columns to format the list of IP Addresses (maximum 4)"
    echo ""
    exit 0
}

# check mandatory arguments were supplied 
if [ "$#" -lt 1 ]; then
  Help
fi

# check if an optional argument is supplied that it is
# suitable to be printed on a standard document page
if [ -z "$columns" ]; then 
    columns=1
elif
    [ "$columns" -lt 1 ] || [ "$columns" -gt 4 ]; then
    Help
else
    echo ""
fi

# create an array to hold the unsorted IP addresses
unsortedArray=()

# add new elements into the array
while read line; do
    unsortedArray+=($line)
done < $filename

# create a sorted and unique array from the unsorted array elements
sortedArray=($(echo "${unsortedArray[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# create the beginning of the html table structure
echo "<table>"
echo "<colgroup>"

# format col and th HTML elements based on user supplied argument
for i in $( seq 1 $columns ); do
    echo "$colwidth"
done

echo "</colgroup>"
echo "<thead>"
echo "<tr>"
for i in $( seq 1 $columns); do
    echo "<th>IP Address</th>"
done

echo "</tr>"
echo "</thead>"
echo "<tbody>"
echo "<tr>"

# format the IP addresses into the specified number of columns
for ip in "${sortedArray[@]}"; do
    for col in $(seq 1 $columns); do
        echo -n "<td>$ip</td>"
    done
    echo "</tr>"
done

# close off the table
echo "</tbody>"
echo "</table>"
