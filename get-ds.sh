#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh gke-kafka-cluster

kubectl get ds --kubeconfig ./kubeconfig.yaml
