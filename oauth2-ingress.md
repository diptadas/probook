
# Ingress External Authentication

https://github.com/kubernetes/ingress-nginx/tree/master/docs/examples/external-auth

## Minikube walkthrough 

### Tunnel minikube using [ngrok](https://ngrok.com/)

```
$ ./ngrok http 192.168.99.100:80 

ngrok by @inconshreveable                                                    (Ctrl+C to quit)
                                                                                             
Session Status                online                                                         
Session Expires               7 hours, 59 minutes                                            
Version                       2.2.8                                                          
Region                        United States (us)                                             
Web Interface                 http://127.0.0.1:4040                                          
Forwarding                    http://3aa55d37.ngrok.io -> 192.168.99.100:80                  
Forwarding                    https://3aa55d37.ngrok.io -> 192.168.99.100:80
```

### Create github [oauth-app](https://github.com/settings/applications/new)

```
callback url: https://3aa55d37.ngrok.io
```

### Enable ingress

```
$ minikube delete; minikube start
$ minikube addons enable ingress
```

### Deploy and expose test server

```
$ kubectl run test-server --image=gcr.io/google_containers/echoserver:1.8
$ kubectl expose deployment test-server --type=LoadBalancer --port=80 --target-port=8080
```

### Deploy and expose oauth2 proxy

```yaml
$ kubectl apply -f oauth2_proxy.yaml

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    k8s-app: oauth2-proxy
  name: oauth2-proxy
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: oauth2-proxy
  template:
    metadata:
      labels:
        k8s-app: oauth2-proxy
    spec:
      containers:
      - args:
        - --provider=github
        - --email-domain=*
        - --upstream=file:///dev/null
        - --http-address=0.0.0.0:4180
        env:
        - name: OAUTH2_PROXY_CLIENT_ID
          value: ...
        - name: OAUTH2_PROXY_CLIENT_SECRET
          value: ...
        - name: OAUTH2_PROXY_COOKIE_SECRET
          # python -c 'import os,base64; print base64.b64encode(os.urandom(16))'
          value: Y/XCgwGzcE/BIkhTtXFcSQ==
        image: docker.io/colemickens/oauth2_proxy:latest
        imagePullPolicy: Always
        name: oauth2-proxy
        ports:
        - containerPort: 4180
          protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  labels:
    k8s-app: oauth2-proxy
  name: oauth2-proxy
spec:
  ports:
  - name: http
    port: 4180
    protocol: TCP
    targetPort: 4180
  selector:
    k8s-app: oauth2-proxy
```

### Create tls secret

```
$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=3aa55d37.ngrok.io"
$ kubectl create secret tls tls-secret --key /tmp/tls.key --cert /tmp/tls.crt
```

### Create ingress

```yaml
$ kubectl apply -f oauth2_ing.yaml

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/auth-signin: https://3aa55d37.ngrok.io/oauth2/start
    nginx.ingress.kubernetes.io/auth-url: https://3aa55d37.ngrok.io/oauth2/auth
  name: external-auth-oauth2
spec:
  rules:
  - host: 3aa55d37.ngrok.io
    http:
      paths:
      - backend:
          serviceName: test-server
          servicePort: 8080
        path: /
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: oauth2-proxy
spec:
  rules:
  - host: 3aa55d37.ngrok.io
    http:
      paths:
      - backend:
          serviceName: oauth2-proxy
          servicePort: 4180
        path: /oauth2
  tls:
  - hosts:
    - 3aa55d37.ngrok.io
    secretName: tls-secret
```

### Run

```
http://3aa55d37.ngrok.io
```
