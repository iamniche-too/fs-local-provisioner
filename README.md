# fs-local-provisioner

For more discussion of local volume provisioning, see:
https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/local-ssd
https://github.com/kubernetes-sigs/sig-storage-local-static-provisioner

## Test cluster

Preamble
Log in as correct gcloud user, etc.
```
gcloud init
```

create 1-node cluster for testing purposes 
gcloud container clusters create test-local-ssd-cluster --num-nodes 1 --zone=europe-west2-a 

view the nodes
```
./describe-nodes.sh
```

delete the default node pool
gcloud container node-pools delete default-pool --cluster test-local-ssd-cluster --zone=europe-west2-a --quiet

create a node pool with 1 local ssd
gcloud container node-pools create node-pool-with-local-ssd --cluster test-local-ssd-cluster --num-nodes 1 --local-ssd-count 1 --zone=europe-west2-a

verify the ssd count 
gcloud container node-pools describe node-pool-with-local-ssd --cluster cluster-name test-local-ssd-cluster --zone=europe-west2-a | grep localSsdCount

Q: why not manually configure the persistent volumes?
A: The node name is required in the config, so every time the cluster is provisioned, a manual intervention is required to update the config (not ideal!)

Q: How are persistent volumes automatically assigned?
A: Using a local provisioner, such as: https://raw.githubusercontent.com/kubernetes-sigs/sig-storage-local-static-provisioner/master/helm/generated_examples/gke.yaml

Note the storage class, as defined in the provisioner
local-scsi

update deployment PVCs of your application e.g.
...
volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            # local ssd is 375 Gb (only)
            storage: 375Gi
        # storage class, as defined in the local-provisioner
        storageClassName: local-scsi

deploy the provisioner to test cluster
```
./deploy-test-cluster.sh
```
serviceaccount/local-static-provisioner created
configmap/local-static-provisioner-config created
storageclass.storage.k8s.io/local-scsi created
clusterrole.rbac.authorization.k8s.io/local-static-provisioner-node-clusterrole created
clusterrolebinding.rbac.authorization.k8s.io/local-static-provisioner-pv-binding created
clusterrolebinding.rbac.authorization.k8s.io/local-static-provisioner-node-binding created
daemonset.apps/local-static-provisioner created

View the DaemonSet
```
./get-ds.sh
```
NAME                       DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
local-static-provisioner   1         1         1       1            1           <none>          3m14s

After the provisioner is running successfully, it creates a PersistentVolume object for each local SSD in the cluster.

View the PVs
```
./get-pv.sh
```
NAME                CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
local-pv-f78d9ed9   368Gi      RWO            Delete           Available           local-scsi              4m55s

Deploy a test pod that uses the local ssd as a volume mount

Note - the pod will be created using namespace test
```
./deploy-all.sh
```

Access the pod
```
./access-test-pod.sh
```

# cd /local-ssd
# ls
lost+found test.txt

VOILA! ;)

