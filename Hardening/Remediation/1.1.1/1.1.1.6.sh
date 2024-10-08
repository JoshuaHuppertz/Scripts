lsmod | grep squashfs
sudo rmmod squashfs
echo -e "install squashfs /bin/false\nblacklist squashfs" | sudo tee /etc/modprobe.d/squashfs.conf