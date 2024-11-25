sudo sh -c "echo '10.0.0.75 factory-registry.com' >> /etc/hosts"


sudo scp registry.crt 102:/home/swarm/ && \
ssh 102 sudo mkdir -p /etc/docker/certs.d/myregistry.com:1994 && \
ssh 102 sudo mv /home/ubuntu/swarm/registry.crt /etc/docker/certs.d/myregistry.com:1994/ca.crt