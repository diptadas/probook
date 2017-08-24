### Minikube allow any token authentication

```
$ minikube start --extra-config=apiserver.Authentication.AnyToken.Allow=true
```