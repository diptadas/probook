# HAProxy Monitoring

**HAProxy config with stats enabled:**

```console
$ cat /tmp/haproxy.cfg

global
    daemon
    maxconn 20

defaults
    log global
    option dontlognull
    timeout connect         5000
    timeout client          50000
    timeout client-fin      50000
    timeout server          50000
    timeout tunnel          1h
    mode http

listen stats 
  bind :9001 
  mode http
  stats enable  
  stats hide-version 
  stats realm Haproxy\ Statistics  
  stats uri /haproxy_stats  
  stats auth user:pass
```

**Run HAProxy container:**

```console
$ docker run -p 9001:9001 -v /tmp/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg haproxy
```

Check stats: http://127.0.0.1:9001/haproxy_stats

**Run haproxy-exporter container:**

```console
$ docker run -p 9101:9101 quay.io/prometheus/haproxy-exporter:v0.9.0 --haproxy.scrape-uri="http://user:pass@127.0.0.1:9001/haproxy_stats;csv"
```

Check exporter: http://127.0.0.1:9101/metrics

**Prometheus config:**

```console
$ cat /tmp/prometheus.yml

global:
  scrape_interval: 5s
scrape_configs:
  - job_name: 'haproxy'
    static_configs:
      - targets: ['127.0.0.1:9101']
```

**Run prometheus container:**

```console
$ docker run -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
```

Check prometheus: http://127.0.0.1:9090