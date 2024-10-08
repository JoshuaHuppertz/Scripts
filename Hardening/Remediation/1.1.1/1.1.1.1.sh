lsmod | grep cramfs
sudo rmmod cramfs
echo -e "install cramfs /bin/false\nblacklist cramfs" | sudo tee /etc/modprobe.d/cramfs.conf