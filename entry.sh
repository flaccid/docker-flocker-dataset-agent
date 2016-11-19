#!/bin/sh -e

# FLOCKER_CONTROL_HOST
# FLOCKER_DATASET_BACKEND
# AWS_REGION
# AWS_AVAILABILITY_ZONE
# AWS_ACCESS_KEY_ID
# AWS_SECRET_KEY

cat <<EOF> /etc/flocker/agent.yml
version: 1
control-service:
  hostname: "$FLOCKER_CONTROL_HOST"
  port: 4524

# The dataset key below selects and configures a dataset backend (see below: aws/openstack/etc).
# All nodes will be configured to use only one backend
EOF

if [ "$FLOCKER_DATASET_BACKEND" = 'aws' ]; then
cat <<EOF>> /etc/flocker/agent.yml
dataset:
   backend: "$FLOCKER_DATASET_BACKEND"
   region: "$AWS_REGION"
   zone: "$AWS_AVAILABILITY_ZONE"
   access_key_id: "$AWS_ACCESS_KEY_ID"
   secret_access_key: "$AWS_SECRET_KEY"
EOF
fi

echo 'Flocker agent.yml configured.'

# set symlinks for the cluster certs
ln -sf /etc/flocker/pki/cluster.crt /etc/flocker/cluster.crt
ln -sf /etc/flocker/pki/cluster.key /etc/flocker/cluster.key

# generate a node certificate
echo 'Generate node certificate.'
cd /etc/flocker
cert_out=$(flocker-ca create-node-certificate)
echo "$cert_out"
cert=$(echo ${cert_out%. Copy*} | cut -d' ' -f2)
key=$(echo ${cert%.crt*}.key)
mv -v "$cert" node.crt
mv -v "$key" node.key

# permission sanity
chmod 0700 /etc/flocker
chmod 0600 /etc/flocker/node.key

echo executing: "$@"
exec "$@"
