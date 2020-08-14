#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh test-local-ssd-cluster

kubectl -n ssd-provision describe pods --kubeconfig ./kubeconfig.yaml
