# Planet API

Example API based on [FastAPI](https://fastapi.tiangolo.com/ "link to FastAPI website").

## Requirements

- [Python 3](https://www.python.org/ "Link to website of Python")
- [Docker](https://www.docker.com/ "Link to the website of Docker")
- [Kubernetes](https://kubernetes.io/ "Link to the website of Kubernetes") (optional)
- [Postman](https://www.postman.com/ "Link to website of Postman") (optional)

## Run the container

```shell
docker run --name api-example -p 8080:8080 testthedocs/planet-api
```

Open your browser on [http://localhost:8080](http://localhost:8080 "Link to localhost on port 8080") to see the welcome message.

## OpenAPI docs

Assuming that the container is running, visit one of the URLs below to browse the docs.

### Swagger UI

[http://localhost:8080/docs](http://localhost:8080/docs "Link to Swagger UI based docs")

![Swagger UI](/docs/assets/swagger-ui.png "Swagger UI")

### Redoc

[http://localhost:8080/redoc](http://localhost:8080/redoc "Link to Redoc based docs")

![Redoc](/docs/assets/redoc.png "Redoc")

## Kubernetes

Use `kubectl` to deploy the API to a Kubernetes cluster.

```shell
kubectl apply -f api.yaml
```

## Postman

You can use Postman for sending API requests.

![Postman](/docs/assets/postman.png "Postman")

