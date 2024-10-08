lsmod | grep udf
sudo rmmod udf
echo -e "install udf /bin/false\nblacklist udf" | sudo tee /etc/modprobe.d/udf.conf