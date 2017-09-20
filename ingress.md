# Ingress Example

Let us consider a [simple-server](https://github.com/diptadas/golang-examples/blob/master/simple_server.go) application.

## Build docker image and push to docker-hub

**Dockerfile**

```dockerfile
FROM ubuntu
ADD ./simple_server simple-server
EXPOSE 9090
```
**Commands**

```console
$ docker build -t diptadas/simple-server .
$ docker push diptadas/simple-server
```

## Create deployment and access using service

**k8s.yaml**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: server-1
  labels:
    app: server-1
spec:
  type: LoadBalancer
  ports:
  - port: 9090
    targetPort: 9090
    nodePort: 30190
  selector:
    app: server-1
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: server-1
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: server-1
    spec:
      containers:
      - name: server-1
        image: diptadas/simple-server
        ports:
        - containerPort: 9090
        command: ["./simple-server", "-arg", "server-1"]
---
apiVersion: v1
kind: Service
metadata:
  name: server-2
  labels:
    app: server-2
spec:
  type: LoadBalancer
  ports:
  - port: 9090
    targetPort: 9090
    nodePort: 30290
  selector:
    app: server-2
---
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: server-2
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: server-2
    spec:
      containers:
      - name: server-2
        image: diptadas/simple-server
        ports:
        - containerPort: 9090
        command: ["./simple-server", "-arg", "server-2"]
```

**Commands**

```console
$ kubectl create -f k8s.yaml

$ kubectl get pods
NAME                        READY     STATUS    RESTARTS   AGE
server-1-2632981092-wwkwv   1/1       Running   0          3m
server-2-2950306407-b4wgv   1/1       Running   0          3m

$ kubectl get svc
NAME         CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
server-1     10.0.0.249   <pending>     9090:30190/TCP   3m
server-2     10.0.0.254   <pending>     9090:30290/TCP   3m

$ kubectl logs -f server-1-2632981092-wwkwv
$ kubectl logs -f server-2-2950306407-b4wgv

$ curl 'http://192.168.99.100:30190?name=dipta&&city=ctg'
server-1:
name=dipta
city=ctg

$ curl 'http://192.168.99.100:30290?name=dipta&&city=ctg'
server-1:
name=dipta
city=ctg
```

## Create ingress and access using hostname

**ingress.yaml**

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    ingress.kubernetes.io/rewrite-target: /
spec:
  backend:
    serviceName: server-1
    servicePort: 9090
  rules:
  - host: myminikube.info
    http:
      paths:
      - path: /one
        backend:
          serviceName: server-1
          servicePort: 9090
      - path: /two
        backend:
          serviceName: server-2
          servicePort: 9090

```

**Commands**

```console
$ kubectl create -f ingress.yaml 
$ echo "192.168.99.100 myminikube.info" | sudo tee -a /etc/hosts

$ curl 'myminikube.info?name=dipta&&city=ctg'
server-1:
name=dipta
city=ctg

$ curl 'myminikube.info/one?name=dipta&&city=ctg'
server-1:
name=dipta
city=ctg

$ curl 'myminikube.info/two?name=dipta&&city=ctg'
server-2:
name=dipta
city=ctg
```