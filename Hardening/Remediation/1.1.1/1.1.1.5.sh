lsmod | grep jffs2
sudo rmmod jffs2
echo -e "install jffs2 /bin/false\nblacklist jffs2" | sudo tee /etc/modprobe.d/jffs2.conf