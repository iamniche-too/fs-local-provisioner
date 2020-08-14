#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh gke-kafka-cluster 

kubectl describe sc $1 --kubeconfig ./kubeconfig.yaml
