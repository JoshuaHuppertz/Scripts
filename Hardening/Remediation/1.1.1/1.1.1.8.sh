lsmod | grep usb-storage
sudo rmmod usb-storage
echo -e "install usb-storage /bin/false\nblacklist usb-storage" | sudo tee /etc/modprobe.d/usb-storage.conf