sudo iptables -t mangle -A OUTPUT -p tcp --dport 8087 -j MARK --set-mark 123
sudo tc qdisc add dev lo root handle 1: prio
sudo tc qdisc add dev lo parent 1:1 handle 10: netem delay 2s
sudo tc filter add dev lo protocol ip parent 1:0 prio 1 u32 match mark 123 0xffff flowid 1:1