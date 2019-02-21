ADMIN="youremail"
ip="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
# set alert level 90% is default
ALERT=90
#df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;
df -khP | column -t | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 }' | while read output;

do
#echo $output  
usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
partition=$(echo $output | awk '{ print $2 }' )
if [ $usep -ge $ALERT ]; then
echo "Running out of space \"$partition ($usep%)\" on $HOSTNAME ($ip)  as on $(date)" | mail -s "Alert: $HOSTNAME ($ip) /Almost out of disk space $usep" $ADMIN
fi
done

exit 0;
