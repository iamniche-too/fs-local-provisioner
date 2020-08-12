#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh test-local-ssd-cluster

#kubectl delete pv local-pv-f78d9ed9 --kubeconfig ./kubeconfig.yaml
#kubectl delete pod local-ssd --kubeconfig ./kubeconfig.yaml
kubectl delete ns test --kubeconfig ./kubeconfig.yaml
