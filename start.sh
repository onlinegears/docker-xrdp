#!/bin/bash

username=$(ls /home)
echo $username
if [ "$username" == "" ]; then
	echo "no username"
	exit 1
fi

echo "username: $username"

homedir=/home/$username
echo "check home dir: $homedir"
if [ ! -d $homedir ]; then
	echo "no homedir"
	exit 1
fi
uid=$(stat -c %u $homedir)
gid=$(stat -c %g $homedir)

echo "create desktop user: $username $uid:$gid"

# password: xrdp
# mkpasswd -m sha-512
pw='$6$S4Upb8X2VhwJAFNE$E646.nUjogS7EWC2vEQUZciV27b7BG/eLdH9bh2QClfoj3qeibisTuMk0oUsmnuF7r85yG4XZliv9BcCzTof9.'
groupadd -g $gid $username
if [ $? -ne 0 ]; then
	"groupadd failed"
	exit 1
fi
useradd -u $uid -g $gid -d $homedir -p $pw -s /bin/bash $username
if [ $? -ne 0 ]; then
	"useradd failed"
	exit 1
fi

# copy skel
for i in /etc/skel/.?*; do
	f=$(basename $i)
	if [ ! -e $homedir/$f ]; then
		cp -a $i $homedir/.
		chown $uid:$gid $homedir/$f
	fi
done

# start xrdp service
xrdp-sesman
ss -nltp
# don't know why, but 1st may fail
xrdp-sesman
ss -nltp
xrdp -n
