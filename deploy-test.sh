#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh test-local-ssd-cluster 

# deploy the DS provisioner
kubectl apply -f ./fs-local-provisioner-v2.3.4.yaml --kubeconfig ./kubeconfig.yaml

# deploy the pod

cat <<EOF | kubectl apply -f - --kubeconfig ./kubeconfig.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: ssd-provision 
  labels:
    cluster: ssd-provision 
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pod-pv-claim
  namespace: ssd-provision
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      # Note - local-ssd is 375Gb, but only 368Gb is addressable...
      storage: 368Gi
  # storage class, as defined in the local-provisioner
  storageClassName: local-scsi
---
apiVersion: v1
kind: Pod
metadata:
  name: ssd-provision-pod
  namespace: ssd-provision
spec:
  containers:
  - name: shell
    image: ubuntu:18.04
    command: ["/bin/sh", "-c"]
    # write to the disk then wait indefinitely (to allow access to the pod to verify output)
    args: ["echo 'hello world' > /local-ssd/hello_world.txt && tail -f /dev/null"]
    volumeMounts:
    - mountPath: /local-ssd/
      name: local-ssd
  volumes:
    - name: local-ssd
      persistentVolumeClaim:
        claimName: pod-pv-claim
EOF
