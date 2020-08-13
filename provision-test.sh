#!/bin/bash
echo "Provisioning cluster test-local-ssd-cluster..."

gcloud container clusters create test-local-ssd-cluster --num-nodes 1 --zone=europe-west2-a

echo "Deleting default node pool..."
gcloud container node-pools delete default-pool --cluster test-local-ssd-cluster --zone=europe-west2-a --quiet

echo "Provisioning node pool..."
# note: labels are used as an example for desired node affinity (as defined in provisioner yaml)
gcloud container node-pools create node-pool-with-local-ssd --cluster test-local-ssd-cluster --num-nodes 1 --local-ssd-count 1 --zone=europe-west2-a --node-labels=node-with-local-ssd=true

echo "Cluster test-local-ssd-cluster provisioned."
