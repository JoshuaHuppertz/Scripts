lsmod | grep hfs
sudo rmmod hfs
echo -e "install hfs /bin/false\nblacklist hfs" | sudo tee /etc/modprobe.d/hfs.conf