#!/bin/bash

#service dnsmasq start
#service ssh start

SERF_CONFIG_DIR=/etc/serf

# if JOIN_IP env variable set generate a config json for serf
[[ -n $JOIN_IP ]] && cat > $SERF_CONFIG_DIR/join.json <<EOF
{
  "start_join" : ["$JOIN_IP"]
}
EOF

[[ -n $JOIN_IP ]] && JOIN_OPTS="-join=$JOIN_IP"

cat > $SERF_CONFIG_DIR/node.json <<EOF
{
  "node_name" : "$(hostname -f)"
}
EOF

/bin/serf agent -rpc-addr=127.0.0.1:7373 -bind=$(hostname -i) -event-handler=/etc/serf/event-router.sh -node=$(hostname -f) "$JOIN_OPTS" -config-dir $SERF_CONFIG_DIR -tag dept=im -snapshot=/home/work/opdir/serf.snapshot > /dev/null 2>&1
