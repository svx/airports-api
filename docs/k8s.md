# Kubernetes

## Delete

In this example, you will delete `aiports-api-v2`.

Delete the deployment in the namespace "apps":

(This will remove all the Pods running the app)

`kubectl delete deployment airports-api-v2 -n apps`

Delete the related API object:

`kubectl delete apis.hub.traefik.io airports-api-v2 -n apps`

Remove the service in the "apps" namespace:

`kubectl delete svc airports-api-v2 -n apps`
