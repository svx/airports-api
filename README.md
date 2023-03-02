# Basic Planet API

Basic example API based on [FastAPI](https://fastapi.tiangolo.com/ "link to FastAPI website").

## Requirements

- [Docker](https://www.docker.com/ "Link to the website of Docker")
- [Kubernetes](https://kubernetes.io/ "Link to the website of Kubernetes") (optional)

## Run the container

```shell
docker run --name api-example -p 8080:8080 testthedocs/planet-api
```

Open your browser on [http://localhost:8080](http://localhost:8080 "Link to localhost on port 8080") to see the welcome message.

## OpenAPI docs

Assuming that the container is running, visit one of the URLs below to browse the docs.

### Swagger UI

[http://localhost:8080/docs](http://localhost:8080/docs "Link to Swagger UI based docs")

### Redoc

[https://localhost:8080/redoc](http://localhost:8080/redocs "Link to Redoc based docs")

## Kubernetes

```shell
kubectl apply -f api.yaml
```
