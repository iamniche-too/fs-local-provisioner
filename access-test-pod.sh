#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh test-local-ssd-cluster

kubectl -n test exec -it test-pod --kubeconfig ./kubeconfig.yaml -- /bin/sh
