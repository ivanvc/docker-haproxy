#!/bin/bash

# Fail hard and fast
set -eo pipefail

export ETCD_PORT=${ETCD_PORT:-4001}
export HOST_IP=${HOST_IP:-172.17.42.1}
export ETCD=$HOST_IP:4001

echo "[haproxy] booting container. ETCD: $ETCD"

# Loop until confd has updated the haproxy config
until confd -onetime -node $ETCD -config-file /etc/confd/conf.d/haproxy.toml; do
  echo "[haproxy] waiting for confd to refresh haproxy.cfg"
  sleep 5
done

# Run confd in the background to watch the upstream servers
confd -interval 10 -node $ETCD -config-file /etc/confd/conf.d/haproxy.toml &
echo "[haproxy] confd is listening for changes on etcd..."

# Start haproxy
echo "[haproxy] starting haproxy service..."
haproxy -f /usr/local/etc/haproxy/haproxy.cfg

# Tail all nginx log files
tail -f /var/log/haproxy.log
