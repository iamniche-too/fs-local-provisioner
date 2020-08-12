#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh

kubectl apply -f ./fs-local-provisioner.yaml --kubeconfig ./kubeconfig.yaml
