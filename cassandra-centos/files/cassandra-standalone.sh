#!/usr/bin/env bash

# https://github.com/spotify/docker-cassandra/blob/master/cassandra/scripts/cassandra-singlenode.sh


CASSANDRA_CONFIG="/etc/cassandra/conf"
# /etc/cassandra/default.conf

# Get running container's IP
IP=`hostname --ip-address`
if [ $# == 1 ]; then SEEDS="$1,$IP"; 
else SEEDS="$IP"; fi


# Dunno why zeroes here
sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/" $CASSANDRA_CONFIG/cassandra.yaml

# Be your own seed
sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$SEEDS\"/" $CASSANDRA_CONFIG/cassandra.yaml

# Listen on IP:port of the container
sed -i -e "s/^listen_address.*/listen_address: $IP/" $CASSANDRA_CONFIG/cassandra.yaml

# With virtual nodes disabled, we need to manually specify the token
echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.initial_token=0\"" >> $CASSANDRA_CONFIG/cassandra-env.sh

# Pointless in one-node cluster, saves about 5 sec waiting time
echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.skip_wait_for_gossip_to_settle=0\"" >> $CASSANDRA_CONFIG/cassandra-env.sh

# Most likely not needed
echo "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=$IP\"" >> $CASSANDRA_CONFIG/cassandra-env.sh

# If configured in $CASSANDRA_DC, set the cassandra datacenter.
if [ ! -z "$CASSANDRA_DC" ]; then
    sed -i -e "s/endpoint_snitch: SimpleSnitch/endpoint_snitch: PropertyFileSnitch/" $CASSANDRA_CONFIG/cassandra.yaml
    echo "default=$CASSANDRA_DC:rac1" > $CASSANDRA_CONFIG/cassandra-topology.properties
fi

cassandra -f