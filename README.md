### Kubernetes Assignment

##### VM Setup:
* Use Vagrant to setup 3 Ubuntu VMs to run the virtual machines cluster. In case of resource crunch on your
machine, you can do 1 master and 1 worker.

1. Use the Vagrantfile to provision 1 master and 2 worker nodes. It will run <b>script.sh</b> to install all dependancies/packages required for K8s cluster setup.

> Ensure swap is disabled.<br>
> Ensure you can run docker as a not-root user.<br>

##### Design Kubernetes Cluster:

1. Initialize k8s cluster using kubeadm init

```
    sudo kubeadm init --apiserver-advertise-address=<master_private_ip> --pod-network-cidr=10.244.0.0/16
```

2. Use the join command to connect worker nodes with the master node.

```
    sudo kubeadm join <master_private_ip>:6443 --token <tokem> --discovery-token-ca-cert-hash <discovery-token-ca-cert-hash>
```

3. Ensure you are using IPVS proxy mode in Kube-proxy.

```
  Install ipvs proxy
  
    sudo apt-get install ipvsadm -y
    sudo modprobe -- ip_vs_rr
    sudo modprobe -- ip_vs_wrr
    sudo modprobe -- ip_vs_sh
    sudo modprobe -- nf_conntrack

    sudo apt install ipset -y
  
  Edit the ConfigMap of kube-proxy<br>
    ...
    kubeProxy:
      config:
        mode: ipvs
    ...
   
  Delete the current kube-proxy pods and check the logs of newly created pods. You should be able to see "Using ipvs Proxier"
```

4. Ensure audit logging is enabled for API server.

```
  Create audit policy file
    ...
    apiVersion: audit.k8s.io/v1
    kind: Policy
    rules:
      - level: Metadata
    ...
  
  Edit the kube-apiserver to use this audit-policy file and to pass filename for saving the logs. Refer to https://medium.com/cooking-with-azure/cks-exam-prep-setting-up-audit-policy-in-kubeadm-3f1b76bf4bd7
  
  Verify that the logs are stored at the defined file.
  
 ```
 
##### Application Setup:

1. Create a bash script to take the backup of ETCD database and run it to take a snapshot

``` 
    Install etcdctl client : sudo apt install etcd-client
    
    Refer to etcd-backup.sh   
```
    
2. Install CNI

```
      kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```


3. Convert https://github.com/StephenGrider/multi-docker (docker compose) app to Kubernetes app in a
namespace training. 
Refer to reactapp_manifests directory.

```     
      kubectl create namespace training
      kubectl apply -f .
```    
Use foodtruck namespace for foodtruck_manifests directory

```
      kubectl create namespace foodtruck
      kubectl apply -f .
```

4. Restrict the number of pods in training namespace to 5. Observe the error by scaling the worker
deployment to 4.

``` 
  Refer to pod-quota.yml

  When trying to scale up worker pods, it does not scale to 4 pods, rather worker deployment gets failed as it exceeds pod-quota of 5 pods in 
  the training namespace
  
```

5. Install nginx ingress controller.

``` 
  Refer to https://medium.com/digitalfrontiers/kubernetes-ingress-with-nginx-93bdc1ce5fa9#:~:text=The%20Ingress%20Controller%20is%20responsible,services%20within%20the%20Kubernetes%20cluster.&text=Thus%20an%20Ingress%20Controller%20can,for%20any%20new%20Ingress%20resources.

      kubectl apply-f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.27.0/deploy/static/mandatory.yaml

  Then apply ingress-resource file and try to access the application through URL prefix.
```

6. Create a network policy in such a way that only server, worker and client are able to connect to redis
and postgresql. All direct connection should be prohibited.

``` 
    Refer to file network-policy.yml

    Once policy is created, use describe command to check if the network conditions are applied.
```

7. Install metrics-server and observe the resource consumption of the workload under training namespace.

```
      kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

  Edit the deployment to add the following flags if not present already.
    1.  --kubelet-preferred-address-types - The priority of node address types used when determining an address for connecting to a particular node (default                 [Hostname,InternalDNS,InternalIP,ExternalDNS,ExternalIP])
    2.  --kubelet-insecure-tls - Do not verify the CA of serving certificates presented by Kubelets. For testing purposes only.
    3.  --requestheader-client-ca-file - Specify a root certificate bundle for verifying client certificates on incoming requests.

      kubectl top nodes
      kubectl top pods
```

8. Run nicolaka/netshoot Github to validate that the network policies are working fine. Observe dns
resolution performance and check connectivity between netshoot to redis/postgresql.


