#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh test-local-ssd-cluster

kubectl -n test get pods --kubeconfig ./kubeconfig.yaml
