#!/bin/bash

# --- Configuration ---
# Number of manager nodes
NUM_MANAGERS=1
# Number of worker nodes
NUM_WORKERS=1
# Docker Machine driver (e.g., virtualbox, digitalocean, aws)
DRIVER="virtualbox" 
# Base name for the machines
MACHINE_NAME_BASE="swarm-node"


# --- Functions ---

create_machine() {
  local role=$1
  local machine_name=$2
  docker-machine create --driver $DRIVER $machine_name 
  if [ "$role" == "manager" ]; then
    docker-machine ssh $machine_name "docker swarm init --advertise-addr $(docker-machine ip $machine_name)"
    JOIN_TOKEN=$(docker-machine ssh $machine_name "docker swarm join-token manager -q")
    echo "Manager join token: $JOIN_TOKEN"
  fi
}

join_swarm() {
  local role=$1
  local machine_name=$2
  if [ "$role" == "worker" ]; then
    docker-machine ssh $machine_name "docker swarm join --token $JOIN_TOKEN $(docker-machine ip $machine_name):2377"
  fi
}

# --- Main ---

# Create manager nodes
for i in $(seq 1 $NUM_MANAGERS); do
  create_machine "manager" "${MACHINE_NAME_BASE}-manager-$i"
done

# Create worker nodes
for i in $(seq 1 $NUM_WORKERS); do
  create_machine "worker" "${MACHINE_NAME_BASE}-worker-$i"
done

# Join worker nodes to the swarm (assuming JOIN_TOKEN is set by the first manager)
for i in $(seq 1 $NUM_WORKERS); do
  join_swarm "worker" "${MACHINE_NAME_BASE}-worker-$i"
done

echo "Docker Swarm cluster created!"

