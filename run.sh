#!/bin/bash

FIRST_IP=$(ip ad show eth0 | grep 'inet ' | awk '{print $2}' | awk -F'/' '{print $1}')
nohup ./serf agent -rpc-addr=127.0.0.1:7373 -bind=$FIRST_IP -node=$(hostname -f) -tag dept=im -snapshot=/home/work/opdir/serf.snapshot > /dev/null 2>&1 &

echo $FIRST_IP

docker run -d --dns 127.0.0.1 -p 34001:22 -e NODE_TYPE=s -P --name cassandra -h cass1.xiahoufeng.com -e JOIN_IP=$FIRST_IP xiahoufeng/cassandra
