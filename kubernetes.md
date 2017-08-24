### Minikube allow any token authentication

```
$ minikube start --extra-config=apiserver.Authentication.AnyToken.Allow=true
```

### Pod restart policy

A PodSpec has a **restartPolicy** field with possible values Always, OnFailure, and Never. The default value is **Always**. If set to **Always** a deployment is created, if set to **OnFailure** a job is created and if set to **Never** a regular pod is created. For the latter two **replicas** must be 1.

```
kubectl run nginx --image=nginx --port=80 --restart=[Always, OnFailure, Never]
```