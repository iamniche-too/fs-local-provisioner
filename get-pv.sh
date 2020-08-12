#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh test-local-ssd-cluster

kubectl get pv --kubeconfig ./kubeconfig.yaml
