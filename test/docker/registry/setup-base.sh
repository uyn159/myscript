#!/bin/bash

# Set the IP address of your master node
MASTER_IP="10.0.0.75" 

# Set the domain name for your registry
REGISTRY_DOMAIN="myregistry.com:5000"

# Get the list of machine names in your swarm
machines=$(docker-machine ls -q)

# Copy registry.crt to master node
docker-machine scp registry.crt master:/home/docker/

# Loop through each machine in the swarm
for machine in $machines; do
  echo "Configuring $machine..."

  # Create the certificate directory
  docker-machine ssh $machine "sudo mkdir -p /etc/docker/certs.d/$REGISTRY_DOMAIN"

  # Copy and rename the certificate
  docker-machine scp registry.crt $machine:/home/docker/
  docker-machine ssh $machine "sudo mv /home/docker/registry.crt /etc/docker/certs.d/$REGISTRY_DOMAIN/ca.crt"

  # Configure local DNS
  docker-machine ssh $machine "sudo sh -c \"echo '$MASTER_IP $REGISTRY_DOMAIN' >> /etc/hosts\""
done

# Copy the certificate and key to the master node
docker-machine scp registry.crt master:/home/docker/
docker-machine scp registry.key master:/home/docker/

# Create the registry service on the master node
docker service create --name registry \
  --publish=5000:5000 \
  --constraint=node.role==manager \
  --mount=type=bind,src=/home/docker,dst=/certs \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
  registry:latest

echo "Registry service created. Check the visualizer at $MASTER_IP:8080"

echo "Build and push your image:"
echo "  docker build . -t $REGISTRY_DOMAIN/server:latest"
echo "  docker push $REGISTRY_DOMAIN/server:latest"

echo "Check your repo:"
echo "  curl -k -X GET https://$REGISTRY_DOMAIN/v2/_catalog"

echo "Create, run and scale your service:"
echo "  docker service create --name=node-server $REGISTRY_DOMAIN/server"
echo "  docker service scale node-server=3"

echo "Observe the changes in the visualizer."