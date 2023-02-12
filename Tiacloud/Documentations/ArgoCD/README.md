# ArgoCD Setup
**********************************************************************************
# Create Kind K8s cluster
```sh
# single node cluster
kind create cluster --name argocd

# multi-node cluster
kind create cluster --config kind-config/cluster.yaml

# export and merge the kind cluster's kubeconfig to your local kubeconfig
kind export kubeconfig --name argocd >> ~/.kube/config

# set the current-content
kind get kubeconfig
```

# ArgoCD Installation
```sh
# Download argocd cli -- For local machine
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

# create argocd namespace
kubectl create namespace argocd

# install argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Patch the ArgoCD service from ClusterIP to a LoadBalancer: -- VERY IMPORTANT for metallb loadbalancer
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

```

# Access ArgoCD Dashboard
```sh
# Get LoadBalancer IP
LB_IP=$(kubectl get svc/argocd-server -n argocd -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Get ArgoCD password
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# port-forward argocd-server service
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Access Dashboar on http://localhost:8080 iwith password below
echo $argoPass
```

# Login to ArgoCD server
```sh
# Login to ArgoCD server
argocd login --insecure --grpc-web http://localhost:8080  --username admin --password $argoPass
```

# Add a Cluster to ArgoCD server
```sh
# Open a new Terminal create a new kind cluster ( as single-node cluster )
kind create cluster --name cluster01

# export and merge the kind cluster's kubeconfig to your local kubeconfig
kind export kubeconfig --name cluster01 >> ~/.kube/config

# Get the endpoint of the cluster you want to add to ArgoCD server
kubectl get endpoints
# ouput
NAME         ENDPOINTS           AGE
kubernetes   192.168.64.2:6443   37h

# Find the entry belonging to the cluster in your .kube/config, and change the server entry:
- cluster:
    certificate-authority-data: ...
    server: https://192.168.64.2:6443 
  name: <thecontext>

# Use the argocd cluser context and perform the following
kubectl config use-context kind-argocd 

# Add the cluster IP to the ArgoCD server
argocd cluster add kind-cluster01   
```

# Create ArgoCD Project
```sh
# create a project named cluster01-project
argocd proj create cluster01-project --description "this project is to deploy only cluster01 applications"

```

# Add Repository to ArgoCD
```sh
# NOTE: ONLY USE THIS IS YOUR APPLICATIONS ARE IN A PRIVATE GIT REPO
# Use your git repo with correct ssh path configured for the git account
argocd repo add git@github.com:<your-repo>.git --ssh-private-key-path ~/.ssh/id_rsa
```

# Create an ArgoCD Application
```yaml
```yaml
# After deploying the app1, you need to register it as an applicaiton in ArgoCD server to monitor it

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app                                          # change to preferred name
  namespace: argocd
spec:
  destination:
    namespace: my-app                                   # change to preferred namespace
    server: https://192.168.64.2:6443                   # This server IP is for cluster01 
  project: default 
  source: 
    path: apps/bgd/overlays/bgd                         # change to path of deployment manifests in github repo
    repoURL: https://github.com/<your-github-repo>/     # Change to correct repo
    targetRevision: HEAD
  syncPolicy: 
    automated:
      prune: true
      selfHeal: false
    syncOptions:
    - CreateNamespace=true
```
```