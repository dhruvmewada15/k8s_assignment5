### Kubernetes Assignment
This repo is the solution of the assignment.

##### VM Setup:
* Use Vagrant to setup 3 Ubuntu VMs to run the virtual machines cluster. In case of resource crunch on your
machine, you can do 1 master and 1 worker.

1. Use the Vagrantfile to provision 1 master and 2 worker nodes. It will run <b>script.sh</b> to install all dependancies/packages required for K8s cluster setup.
2. ```vagrant up```

> Ensure swap is disabled.<br>
> Ensure you can run docker as a not-root user.<br>

##### Design Kubernetes Cluster:

1. Initialize k8s cluster using kubeadm init

```sudo kubeadm init --apiserver-advertise-address=<master_private_ip> --pod-network-cidr=10.244.0.0/16```

2. Use the join command to connect worker nodes with the master node.

```sudo kubeadm join <master_private_ip>:6443 --token <tokem> --discovery-token-ca-cert-hash <discovery-token-ca-cert-hash>```

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
   
  Delete the current kube-proxy pods. and check the logs of newly created pods. You should be able to see "Using ipvs Proxier"
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
  
  Edit the kube-apiserver to use this audit-policy file and 
  
 ```
 
