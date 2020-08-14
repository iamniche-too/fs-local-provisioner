#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh gke-kafka-cluster 

# delete any Released PVs 
kubectl get pv --kubeconfig ./kubeconfig.yaml | grep Released | awk '$1 {print$1}' | while read vol; do kubectl delete pv/${vol} --kubeconfig ./kubeconfig.yaml; done

# delete any Available PVs
kubectl get pv --kubeconfig ./kubeconfig.yaml | grep Available | awk '$1 {print$1}' | while read vol; do kubectl delete pv/${vol} --kubeconfig ./kubeconfig.yaml; done
