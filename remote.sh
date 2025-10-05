./create_package.sh
scp os-mosdns-5.3.3.txz root@192.168.36.8:/root
ssh root@192.168.36.8 'cd / && pkg delete -y os-mosdns ; pkg install -y /root/os-mosdns-5.3.3.txz && reboot'
date
