kind create cluster --name sre-demo

curl -sSL https://get.ambientmesh.io | bash -
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.26/samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.26/samples/bookinfo/gateway-api/bookinfo-gateway.yaml
kubectl apply -f https://get.ambientmesh.io/monitoring.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.26/samples/addons/grafana.yaml

kubectl label namespace default istio.io/dataplane-mode=ambient

kubectl annotate gateway bookinfo-gateway networking.istio.io/service-type=ClusterIP --namespace=default

istioctl waypoint apply -n default --enroll-namespace

kubectl port-forward svc/bookinfo-gateway-istio 8080:80 &
while true; do curl http://localhost:8080/productpage; sleep 1; done

# Used in the github-mcp.yaml
kubectl create secret generic githubsecret -n kagent --from-literal=token=$GITHUB_TOKEN

# install kagent
kagent install -n kagent
kubectl port-forward -n kagent svc/kagent-ui 8001:8080

# Deploy the Github MCP and SRECon demo agent
kubectl apply -f github-mcp.yaml
kubectl apply -f srecon-agent-demo.yaml
