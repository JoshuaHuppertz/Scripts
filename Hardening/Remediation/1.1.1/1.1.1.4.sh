lsmod | grep hfsplus
sudo rmmod hfsplus
echo -e "install hfsplus /bin/false\nblacklist hfsplus" | sudo tee /etc/modprobe.d/hfsplus.conf