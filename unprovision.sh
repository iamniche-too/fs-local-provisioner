#!/bin/bash
echo "Unprovisioning cluster test-local-ssd-cluster..."
gcloud container clusters delete test-local-ssd-cluster --zone=europe-west2-a --quiet
echo "Cluster test-local-ssd-cluster unprovisioned."
