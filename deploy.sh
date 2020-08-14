#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh gke-kafka-cluster 

# deploy the DS provisioner
kubectl apply -f ./fs-local-provisioner-v2.3.4-kafka.yaml --kubeconfig ./kubeconfig.yaml
