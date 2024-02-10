
sudo iptables -t mangle -D OUTPUT -p tcp --dport 8087 -j MARK --set-mark 123
sudo tc filter del dev lo protocol ip parent 1:0 prio 1
sudo tc qdisc del dev lo parent 1:1 handle 10:
sudo tc qdisc del dev lo root handle 1: