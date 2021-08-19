# Kubernetes

## Install/Update minikube, kubectl

```
$ curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

$ curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

## Create pod without deployment

```
$ kubectl run nginx --image=nginx --port=80 --restart=[Always, OnFailure, Never]
```

- If set to `Always` a deployment is created
- `OnFailure` a job is created
- `Never` a regular pod is created. 
- `--replicas` must be 1 for `OnFailure` and `Never` 
- Default is `Always`

## Access pod using service

```
$ kubectl expose deployment my-deployment --type=LoadBalancer --name=my-service
$ minikube service --url my-service
$ minikube service my-service (open in browser)
```

## Access pod using port forward

```
$ kubectl port-forward {pod-name} {port}
```

## Ingress tutorials

- https://kubernetes.io/docs/concepts/services-networking/ingress/
- https://medium.com/@Oskarr3/setting-up-ingress-on-minikube-6ae825e98f82

## Delete Job without deleting Pods

```
$ kubectl delete jobs/old --cascade=false
```

## Infinite pod

```
apiVersion: v1
kind: Pod
metadata:
  name: kubectl-pod
spec:
  containers:
  - image: diptadas/kubectl
    name: kubectl-container
    command: ["sh", "-c", "tail -f /dev/null"]
  restartPolicy: Never
```

## Enable Initializer RBAC

```
$ minikube start --extra-config=apiserver.Admission.PluginNames="Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota"
```

## Enable RBAC minikube

```
$ minikube delete; minikube start --extra-config=apiserver.Authorization.Mode=RBAC

$ kubectl create serviceaccount kube-dns -n kube-system; kubectl patch deployment kube-dns -n kube-system -p '{"spec":{"template":{"spec":{"serviceAccountName":"kube-dns"}}}}'
```

## Minikube link with host's docker

```
$ docker save <image-name> | (eval $(minikube docker-env) && docker load)
```

## Minikube enable webhook

```
$ minikube delete; minikube start --extra-config=apiserver.Admission.PluginNames="NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,DefaultTolerationSeconds,MutatingAdmissionWebhook,ValidatingAdmissionWebhook,ResourceQuota"
```

## `nano` not working inside pod exec

```
$ apt update
$ apt install rxvt-unicode nano
```

## Change kube editor

```
$ KUBE_EDITOR="nano" kubectl edit svc/mysvc
```

## Super user permission to all service accounts

```
$ kubectl create clusterrolebinding serviceaccounts-cluster-admin \
  --clusterrole=cluster-admin \
  --group=system:serviceaccounts
```

## Install dashboard

```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

$ kubectl proxy
```

- http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/namespace?namespace=_all

## TLS secret

```
$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=voyager.appscode.test"

$ kubectl create secret tls tls-secret --key /tmp/tls.key --cert /tmp/tls.crt
```

### Minikube allow any token authentication

```
$ minikube start --extra-config=apiserver.Authentication.AnyToken.Allow=true
```

## Pod restart policy

A PodSpec has a **restartPolicy** field with possible values Always, OnFailure, and Never. The default value is **Always**. If set to **Always** a deployment is created, if set to **OnFailure** a job is created and if set to **Never** a regular pod is created. For the latter two **replicas** must be 1.

```
kubectl run nginx --image=nginx --port=80 --restart=[Always, OnFailure, Never]
```

## Subject Access Review

Service accounts authenticate with the username `system:serviceaccount:(NAMESPACE):(SERVICEACCOUNT)` and are assigned to the groups `system:serviceaccounts` and `system:serviceaccounts:(NAMESPACE)`.

```console
$ kubectl create rolebinding default-view --clusterrole=view --serviceaccount=default:default --namespace=default
```

```yaml
$ kubectl create -f - -o yaml << EOF
apiVersion: authorization.k8s.io/v1
kind: SubjectAccessReview
spec:
  groups:
  - system:serviceaccounts
  - system:serviceaccounts:default
  user: system:serviceaccount:default:default
  resourceAttributes:
    group: extensions
    version: v1beta1
    resource: deployments
    namespace: default
    verb: get
EOF
```

```console
$ kubectl auth can-i get deployments --namespace default --as system:serviceaccount:default:default
```

## Kubectl get json-path

```yaml
$ kubectl create -f - -o yaml << EOF
kind: ConfigMap
apiVersion: v1
metadata:
  name: my-config
  namespace: default
data:
  example.property.1: hello
  example.property.2: world
EOF
```

```console
$ kubectl get configmap my-config -o jsonpath='{.data.example\.property\.1}'
hello
```
