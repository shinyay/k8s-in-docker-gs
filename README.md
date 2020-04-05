# Kubernetes in Docker (KIND) Getting Started

Overview

## Description

## Demo

## Features

- feature:1
- feature:2

## Requirement

## Usage
### Installation
```
$ brew install kind
```

### kind cli
```
$ kind -h

kind creates and manages local Kubernetes clusters using Docker container 'nodes'

Usage:
  kind [command]

Available Commands:
  build       Build one of [base-image, node-image]
  completion  Output shell completion code for the specified shell (bash or zsh)
  create      Creates one of [cluster]
  delete      Deletes one of [cluster]
  export      Exports one of [kubeconfig, logs]
  get         Gets one of [clusters, nodes, kubeconfig]
  help        Help about any command
  load        Loads images into nodes
  version     Prints the kind CLI version

Flags:
  -h, --help              help for kind
      --loglevel string   DEPRECATED: see -v instead
  -q, --quiet             silence all stderr output
  -v, --verbosity int32   info log verbosity
      --version           version for kind

Use "kind [command] --help" for more information about a command.
```

### Create Cluster
```
$ kind create cluster -h

Creates a local Kubernetes cluster using Docker container 'nodes'

Usage:
  kind create cluster [flags]

Flags:
      --config string       path to a kind config file
  -h, --help                help for cluster
      --image string        node docker image to use for booting the cluster
      --kubeconfig string   sets kubeconfig path instead of $KUBECONFIG or $HOME/.kube/config
      --name string         cluster context name (default "kind")
      --retain              retain nodes for debugging when cluster creation fails
      --wait duration       wait for control plane node to be ready (default 0s)

Global Flags:
      --loglevel string   DEPRECATED: see -v instead
  -q, --quiet             silence all stderr output
  -v, --verbosity int32   info log verbosity
```

```
$ kind create cluster --name kind-cluster

Creating cluster "kind-cluster" ...
 ✓ Ensuring node image (kindest/node:v1.17.0) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-kind-cluster

Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂
```

### Confirm Cluster
```
$ kubectl config get-contexts
CURRENT   NAME                                                  CLUSTER                                               AUTHINFO                                              NAMESPACE
          gke_pa-syanagihara_us-central1-a_standard-cluster-1   gke_pa-syanagihara_us-central1-a_standard-cluster-1   gke_pa-syanagihara_us-central1-a_standard-cluster-1
*         kind-kind-cluster                                     kind-kind-cluster                                     kind-kind-cluster
          minikube                                              minikube                                              minikube
```

```
$ docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                       NAMES
72dd3c3f41ac        kindest/node:v1.17.0   "/usr/local/bin/entr…"   11 minutes ago      Up 10 minutes       127.0.0.1:32768->6443/tcp   kind-cluster-control-plane
```

### Confirm Nodes
```
$ kubectl get nodes -o wide
NAME                         STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION     CONTAINER-RUNTIME
kind-cluster-control-plane   Ready    master   24h   v1.17.0   172.17.0.2    <none>        Ubuntu 19.10   4.19.76-linuxkit   containerd://1.3.2
```

### Delete Cluster
```
$ kind delete cluster --name kind-cluster
Deleting cluster "kind-cluster" ...

$ kind get clusters
No kind clusters found.

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

### Multi-node Clusters

```
$ vim multi-node-1cp-2wk.yml

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
```

```
$ kind create cluster --name multi --config multi-node-1cp-2wk.yml

Creating cluster "multi" ...
 ✓ Ensuring node image (kindest/node:v1.17.0) 🖼
 ✓ Preparing nodes 📦 📦 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
 ✓ Joining worker nodes 🚜
Set kubectl context to "kind-multi"
You can now use your cluster with:

kubectl cluster-info --context kind-multi

Thanks for using kind! 😊
```

```
$ kind get cluster

multi
```

```
$ kubectl get nodes -o wide

NAME                  STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION     CONTAINER-RUNTIME
multi-control-plane   Ready    master   15m   v1.17.0   172.17.0.4    <none>        Ubuntu 19.10   4.19.76-linuxkit   containerd://1.3.2
multi-worker          Ready    <none>   14m   v1.17.0   172.17.0.3    <none>        Ubuntu 19.10   4.19.76-linuxkit   containerd://1.3.2
multi-worker2         Ready    <none>   14m   v1.17.0   172.17.0.2    <none>        Ubuntu 19.10   4.19.76-linuxkit   containerd://1.3.2
```

### Specific Kubernetes version

- `kind create cluster --image kindest/node:vX.XX.X` 
  - [KIND version](https://hub.docker.com/r/kindest/node/tags)

```
$ kind create cluster --image kindest/node:v1.15.7

Creating cluster "kind" ...
 ✓ Ensuring node image (kindest/node:v1.15.7) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind"
You can now use your cluster with:

kubectl cluster-info --context kind-kind
```

```
$ kubectl get nodes -o wide

NAME                 STATUS   ROLES    AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION     CONTAINER-RUNTIME
kind-control-plane   Ready    master   6m38s   v1.15.7   172.17.0.2    <none>        Ubuntu 19.10   4.19.76-linuxkit   containerd://1.3.2
```

### Extra port mapping
```yaml
kind: Cluster
apiVersion: kind.sigs.k8s.io/v1alpha3
nodes:
- role: control-plane
- role: worker
  extraPortMappings:
  - containerPort: 30001
    hostPort: 30001
```

```
$ docker ps

CONTAINER ID        IMAGE                  COMMAND                  CREATED              STATUS              PORTS                       NAMES
859e4b98a8e8        kindest/node:v1.17.0   "/usr/local/bin/entr…"   About a minute ago   Up About a minute   0.0.0.0:30001->30001/tcp    kind-worker
47b9ae1f6167        kindest/node:v1.17.0   "/usr/local/bin/entr…"   About a minute ago   Up About a minute   127.0.0.1:32776->6443/tcp   kind-control-plane
```

### Ingress Controller - NGINX
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/deploy/)

#### Cluster for Ingress Controller
- **extraPortMappings**
- **node-labels**

```
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
        authorization-mode: "AlwaysAllow"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
```

#### Prerequisite Generic Deployment Command
```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml

namespace/ingress-nginx created
configmap/nginx-configuration created
configmap/tcp-services created
configmap/udp-services created
serviceaccount/nginx-ingress-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-role created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-role-nisa-binding created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-clusterrole-nisa-binding created
deployment.apps/nginx-ingress-controller created
limitrange/ingress-nginx created
```

#### Provider Specific Configuration
```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/provider/cloud-generic.yaml

service/ingress-nginx created
```

#### Verification for installation
```
$ kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx --watch

NAMESPACE       NAME                                        READY   STATUS    RESTARTS   AGE
ingress-nginx   nginx-ingress-controller-7f74f657bd-gv2gt   1/1     Running   0          24m
```

- EXTERNAL-IP: `<pending>`
```
$ kubectl get services -n ingress-nginx -owide

NAME            TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE   SELECTOR
ingress-nginx   LoadBalancer   10.96.180.192   <pending>     80:32511/TCP,443:30877/TCP   11m   app.kubernetes.io/name=ingress-nginx,app.kubernetes.io/part-of=ingress-nginx  containerd://1.3.2
```

#### Expose Ingess from KIND at Bare-metal
```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/baremetal/service-nodeport.yaml

service/ingress-nginx configured
```

```
$ kubectl get services -n ingress-nginx -owide

NAME            TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE   SELECTOR
ingress-nginx   NodePort   10.96.180.192   <none>        80:32511/TCP,443:30877/TCP   51m   app.kubernetes.io/name=ingress-nginx,app.kubernetes.io/part-of=ingress-nginx
```

#### Detect installed version
```
$ set POD_NAMESPACE ingress-nginx

$ set POD_NAME (kubectl get pods -n $POD_NAMESPACE -l app.kubernetes.io/name=ingress-nginx -o jsonpath='{.items[0].metadata.name}')

$ kubectl exec -it $POD_NAME -n $POD_NAMESPACE -- /nginx-ingress-controller --version

#### Patch to forward hostPorts to Ingress Controller
```json
{
  "spec": {
    "template": {
      "spec": {
        "containers": [
        {
          "name": "nginx-ingress-controller",
          "ports": [
          {
            "containerPort": 80,
            "hostPort": 80
          },
          {
            "containerPort": 443,
            "hostPort": 443
          }
          ]
        }
        ],
        "nodeSelector": {
          "ingress-ready": "true"
        },
        "tolerations": [
        {
          "key": "node-role.kubernetes.io/master",
          "operator": "Equal",
          "effect": "NoSchedule"
        }
        ]
      }
    }
  }
}
```

```
$ kubectl patch deployments -n ingress-nginx nginx-ingress-controller -p '{"spec":{"template":{"spec":{"containers":[{"name":"nginx-ingress-controller","ports":[{"containerPort":80,"hostPort":80},{"containerPort":443,"hostPort":443}]}],"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'
```

```
-------------------------------------------------------------------------------
NGINX Ingress controller
  Release:       0.30.0
  Build:         git-7e65b90c4
  Repository:    https://github.com/kubernetes/ingress-nginx
  nginx version: nginx/1.17.8

-------------------------------------------------------------------------------
```

### Istio
#### Kind Cluster for Istio with Mapping ports to the host machine
- Open `30080` port for NodePort as extraPortMappings
  - You can map extra ports from the nodes to the host machine with extraPortMappings

kind-config-istio.yml
```yaml
kind: Cluster
apiVersion: kind.sigs.k8s.io/v1alpha3
nodes:
- role: control-plane
- role: worker
  extraPortMappings:
  - containerPort: 30080
    hostPort: 30080
```

```
$ kind create cluster --config kind-config-istio.yml
```

```
$ kubectl config get-contexts
$ kubectl cluster-info --context kind-kind
$ kubectl config use-context kind-kind
```

#### App deployment for Kind Cluster
```
$ docker pull shinyay/envweb:0.0.1
$ kind load docker-image shinyay/envweb:0.0.1
```

```
$ docker exec -it kind-worker crictl images

IMAGE                                      TAG                 IMAGE ID            SIZE
docker.io/kindest/kindnetd                 0.5.4               2186a1a396deb       113MB
docker.io/rancher/local-path-provisioner   v0.0.11             9d12f9848b99f       36.5MB
docker.io/shinyay/envweb                   0.0.1               4ab3467743a10       13.3MB
k8s.gcr.io/coredns                         1.6.5               70f311871ae12       41.7MB
k8s.gcr.io/debian-base                     v2.0.0              9bd6154724425       53.9MB
k8s.gcr.io/etcd                            3.4.3-0             303ce5db0e90d       290MB
k8s.gcr.io/kube-apiserver                  v1.17.0             134ad2332e042       144MB
k8s.gcr.io/kube-controller-manager         v1.17.0             7818d75a7d002       131MB
k8s.gcr.io/kube-proxy                      v1.17.0             551eaeb500fda       132MB
k8s.gcr.io/kube-scheduler                  v1.17.0             09a204f38b41d       112MB
k8s.gcr.io/pause                           3.1                 da86e6ba6ca19       746kB
```

#### Istio download & deploy
```
$ curl -L https://istio.io/downloadIstio | sh -
$ cp istio-*/bin/istioctl /usr/local/bin/
$ istioctl manifest apply --set profile=default
```

|Core Components|default|demo|minimal|remote|
|---------------|-------|----|-------|------|
|istio-egressgateway||X|||
|istio-ingressgateway|X|X|||
|istio-pilot|X|X|X||

|Addons|default|demo|minimal|remote|
|------|-------|----|-------|------|
|grafana||X|||
|istio-tracing||X|||
|kiali||X|||
|prometheus|X|X||X|

```
$ kubectl -n istio-system get svc

NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                                                                                                                                      AGE
istio-ingressgateway   LoadBalancer   10.96.19.235    <pending>     15020:32549/TCP,80:32137/TCP,443:32497/TCP,15029:31629/TCP,15030:30294/TCP,15031:30602/TCP,15032:31748/TCP,15443:32423/TCP,31400:31451/TCP   10m
istio-pilot            ClusterIP      10.96.133.178   <none>        15010/TCP,15011/TCP,15012/TCP,8080/TCP,15014/TCP,443/TCP                                                                                     20m
istiod                 ClusterIP      10.96.214.109   <none>        15012/TCP,443/TCP                                                                                                                            20m
prometheus             ClusterIP      10.96.190.234   <none>        9090/TCP                                                                                                                                     10m
```

## Installation

## Licence

Released under the [MIT license](https://gist.githubusercontent.com/shinyay/56e54ee4c0e22db8211e05e70a63247e/raw/34c6fdd50d54aa8e23560c296424aeb61599aa71/LICENSE)

## Author

[shinyay](https://github.com/shinyay)
