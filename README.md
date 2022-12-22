# terraform-eks
terraform eks echo deploy

## CI/CD

## eks addon

## Service Mesh
1. Istio helm (base,istiod,gateway)
레포 확인
- https://artifacthub.io/packages/search?kind=0&org=istio&ts_query_web=istio&official=true&sort=relevance&page=1
- Dependency: base -> istiod -> gateway(NodePort) -> ingress(alb)
- prometheus-operator 용 pod,service 모니터 추가 배포
- istio-ingres_gateway: alb 기반 tls termination 구성

## Monitoring
1. Prometheus-stack helm (prometheus,grafana,alertmanager)
- helm values 사용

2. Kiali helm (operator,cr기반 core)
- crd.yaml 사용
- Dependency: istio, prometheus-stack

## Log Pipeline

