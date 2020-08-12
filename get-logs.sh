#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh test-local-ssd-cluster

kubectl -n test logs test-pod --kubeconfig ./kubeconfig.yaml
