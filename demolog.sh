cat >/root/abc.sh << 'EOF'
#!bin bash

# To create list of running ssh PID's in pidls file
ps -C ssh -o pid= >> /root/pidls.txt

# To list down running ssh sessions in lines file
ps -eo user:16,stime,pid,cmd | grep -w ssh | grep -v grep > /root/lines.txt

# Create a variable to store date
sdate=`date +%D`

# To remove duplicate entries of PID's created due to cronjob
cat /root/pidls.txt | sort -u > uniquepid.txt

# To define line in for loop as line entity
IFS=$'\n'

# Take each line in lines file and append date to it
for line in `cat /root/lines.txt`
do
echo $sdate $line >> /root/tmplog.txt
done
diff --changed-group-format='%<' --unchanged-group-format=''  /root/tmplog.txt /root/log.txt >> /root/log.txt

rm –f   /root/tmplog.txt
# To check if PID still running and if not give expiry date of PID
for pid in `cat /root/uniquepid.txt`

do

kill -0 $pid 2> /dev/null

if [ `echo $?` -ne 0 ]

then

echo "`date +%D` session of PID  $pid  expired :`date +%T`" >> /root/log.txt

sed -i "s/$pid//g" pidls.txt

sed -i '/ $/d' pidls.txt

fi

done

EOF
