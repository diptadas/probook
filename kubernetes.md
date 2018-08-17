### Minikube allow any token authentication

```
$ minikube start --extra-config=apiserver.Authentication.AnyToken.Allow=true
```

### Pod restart policy

A PodSpec has a **restartPolicy** field with possible values Always, OnFailure, and Never. The default value is **Always**. If set to **Always** a deployment is created, if set to **OnFailure** a job is created and if set to **Never** a regular pod is created. For the latter two **replicas** must be 1.

```
kubectl run nginx --image=nginx --port=80 --restart=[Always, OnFailure, Never]
```

### Subject Access Review

Service accounts authenticate with the username `system:serviceaccount:(NAMESPACE):(SERVICEACCOUNT)` and are assigned to the groups `system:serviceaccounts` and `system:serviceaccounts:(NAMESPACE)`.

```console
$ kubectl create rolebinding default-view --clusterrole=view --serviceaccount=default:default --namespace=default
```

```yaml
kubectl create -f - -o yaml << EOF
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