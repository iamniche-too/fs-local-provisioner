#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh gke-kafka-cluster 

# undeploy the DS provisioner
kubectl delete -f ./fs-local-provisioner-v2.3.4.yaml --kubeconfig ./kubeconfig.yaml
