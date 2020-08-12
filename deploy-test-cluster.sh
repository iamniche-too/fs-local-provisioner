#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh test-local-ssd-cluster

# 2.3.3
# kubectl apply -f ./fs-local-provisioner-v2.3.3.yaml --kubeconfig ./kubeconfig.yaml

# 2.3.4
kubectl apply -f ./fs-local-provisioner-v2.3.4.yaml --kubeconfig ./kubeconfig.yaml
