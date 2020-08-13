#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh test-local-ssd-cluster

kubectl delete ns ssd-provision --kubeconfig ./kubeconfig.yaml
