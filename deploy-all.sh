#!/bin/bash
source ./export-gcp-credentials.sh
./generate-cluster-connection-yaml.sh test-local-ssd-cluster

cat <<EOF | kubectl apply -f - --kubeconfig ./kubeconfig.yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: test 
  labels:
    cluster: test 
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pod-pv-claim
  namespace: test
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
  name: test-pod
  namespace: test
spec:
  containers:
  - name: shell
    image: ubuntu:18.04
    command: ["/bin/sh", "-c"]
    # write to the disk then wait indefinitely (to allow access to the pod to verify output)
    args: ["echo 'hello world' > /local-ssd/test.txt && tail -f /dev/null"]
    volumeMounts:
    - mountPath: /local-ssd/
      name: local-ssd
  volumes:
    - name: local-ssd
      persistentVolumeClaim:
        claimName: pod-pv-claim
EOF
