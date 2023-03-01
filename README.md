# Basic Planet API

Basic example API based on [FastAPI](https://fastapi.tiangolo.com/ "link to FastAPI website").

## Run the container

```shell
docker run --name api-example -p 8080:8080 testthedocs/planet-api
```

Open your browser on [http://localhost:8080](http://localhost:8080 "Link to localhost on port 8080") to see the welcome message.

## OpenAPI docs

### Swagger UI

[http://localhost:8080/docs](http://localhost:8080/docs "Link to Swagger UI based docs")

### Redoc

[https://localhost:8080/redoc](http://localhost:8080/redocs "Link to Redoc based docs")

## Kubernetes

```shell
kubectl apply -f api.yaml
```
