# terraform-eks
terraform eks echo deploy

## CI/CD

## eks addon

## Service Mesh
Istio 기반 helm 배포 
레포 확인
- https://artifacthub.io/packages/search?kind=0&org=istio&ts_query_web=istio&official=true&sort=relevance&page=1
- Dependency: base -> istiod -> gateway(NodePort) -> ingress(alb)
- Helm value 사용 
- prometheus-operator 용 pod,service 모니터 추가 배포
- istio-ingres_gateway: alb 기반 tls termination 구성

## Monitoring

## Log Pipeline

