

```sh
 # Add helm repo
  helm repo add opensearch https://opensearch-project.github.io/helm-charts/

# install components
helm install opensearch-master opensearch/opensearch -f master.yaml
helm install opensearch-data opensearch/opensearch -f data.yaml
helm install opensearch-client opensearch/opensearch -f client.yaml

helm uninstall opensearch-client opensearch/opensearch f client.yaml

helm install tiacloud-opensearch opensearch/opensearch

 # dashboard
helm install dashboards opensearch/opensearch-dashboards

 # Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=opensearch-dashboards,app.kubernetes.io/instance=dashboards" -o jsonpath="{.items[0].metadata.name}")

  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")

  echo "Visit http://127.0.0.1:8080 to use your application"

  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT

```




```sh
helm repo add doca https://charts.doca.cloud/charts

helm install tia-opensearch doca/opensearch


```