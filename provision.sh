#!/bin/bash
echo "Provisioning cluster test-local-ssd-cluster..."
gcloud container clusters create test-local-ssd-cluster --num-nodes 1 --zone=europe-west2-a
gcloud container node-pools delete default-pool --cluster test-local-ssd-cluster --zone=europe-west2-a --quiet
gcloud container node-pools create node-pool-with-local-ssd --cluster test-local-ssd-cluster --num-nodes 1 --local-ssd-count 1 --zone=europe-west2-a
echo "Cluster test-local-ssd-cluster provisioned."
