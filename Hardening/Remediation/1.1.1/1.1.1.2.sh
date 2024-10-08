lsmod | grep freevxfs
sudo rmmod freevxfs
echo -e "install freevxfs /bin/false\nblacklist freevxfs" | sudo tee /etc/modprobe.d/freevxfs.conf