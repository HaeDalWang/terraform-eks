# terraform-eks

terraform eks echo deploy

- oidc_provier 

## EKS Common

- Metrics Server
- Cluster Autoscaler
- AWS Loadbalancer controller
- External DNS

## CI/CD

1. CI: Github Action

- 준비중

2. CD: Argocd helm

- value 파일 사용 
    + --insecure 적용
    + 추가 ingress 배포 (alb)

## Service Mesh

1. Istio helm (base,istiod)
레포 확인

- https://artifacthub.io/packages/search?kind=0&org=istio&ts_query_web=istio&official=true&sort=relevance&page=1
- Dependency: base -> istiod
- prometheus-operator 용 pod,service 모니터 추가 배포
- gateway로 AWS-Loadbalancer-controller 사용 가정
    + istio-gateway-controller 부분 주석으로 추가 

## Monitoring

1. Prometheus-stack helm (prometheus,grafana,alertmanager)

- helm values 사용

2. Kiali helm (operator,)

- cr 예제 미리 제작후 op 배포시 같이 배포
    + ingress 추가배포(alb)

- Dependency: istio, prometheus-stack

## Log Pipeline

1. AWS Opensearch + Fluent-bit 
- filter & parse  = all index 수정 필요

