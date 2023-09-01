# Airports API

Example API based on [FastAPI](https://fastapi.tiangolo.com/ "Link to FastAPI website").

## Requirements

- [Python 3](https://www.python.org/ "Link to website of Python")
- [Docker](https://www.docker.com/ "Link to the website of Docker")
- [Kubernetes](https://kubernetes.io/ "Link to the website of Kubernetes") (optional)

## Docker

### Run the container

This API comes in two versions, `v1` and `v2`.

Version `v2` includes one more airport.

> Do not get confused, the versions are running on different ports!

- `v1`: Port 8080
- `v2`: port 8090

#### API version 1

```shell
docker run --rm --name api-example-v1 -p 8080:8080 testthedocs/airports-api-v1
```

Open your browser on [http://localhost:8080](http://localhost:8080 "Link to localhost on port 8080") to see the welcome message.

#### API version 2

```shell
docker run --rm --name api-example-v2 -p 8090:8080 testthedocs/airports-api-v2
```

Open your browser on [http://localhost:8090](http://localhost:8090 "Link to localhost on port 8080") to see the welcome message.

### OpenAPI docs

You can choose to display the OpenAPI spec using Swagger UI or Redoc.

#### Version 1

Assuming that the container is running, visit one of the URLs below to browse the docs.

##### Swagger UI

[http://localhost:8080/docs](http://localhost:8080/docs "Link to Swagger UI based docs")

![Swagger UI](/docs/assets/airports-api-v1-swagger-ui.png "Swagger UI")

##### Redoc

[http://localhost:8080/redoc](http://localhost:8080/redoc "Link to Redoc based docs")

![Redoc](/docs/assets/airports-api-v1-redoc.png "Redoc")

#### Version 2

Assuming that the container is running, visit one of the URLs below to browse the docs.

##### Swagger UI

[http://localhost:8090/docs](http://localhost:8090/docs "Link to Swagger UI based docs")

![Swagger UI](/docs/assets/airports-api-v2-swagger-ui.png "Swagger UI")

##### Redoc

[http://localhost:8090/redoc](http://localhost:8090/redoc "Link to Redoc based docs")

![Redoc](/docs/assets/airports-api-v2-redoc.png "Redoc")

## Kubernetes

Use `kubectl` to deploy the versioned API to a Kubernetes cluster.

```shell
kubectl apply -f k8s/airports/versioning
```

## Examples

All requests in the examples below are made against the Airports API version 2.

### HTTPie

Use [HTTPie](https://httpie.io/ "Link to website of HTTPie") and get airport information by ID:

```shell
http GET localhost:9000/airports/2

HTTP/1.1 200 OK
content-length: 152
content-type: application/json
date: Tue, 15 Aug 2023 13:46:08 GMT
server: uvicorn

{
    "city": "Lyon",
    "iata": "LYS",
    "id": 2,
    "name": "Lyon–Saint Exupéry Airport",
    "url": "https://en.wikipedia.org/wiki/Lyon%E2%80%93Saint-Exup%C3%A9ry_Airport"
}
```

### Curl combined with jq

The following example show the same request using `curl` combined with `jq`:

```shell
 curl -X 'GET' \
  'http://localhost:9000/airports/2' \
  -H 'accept: application/json' | jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   152  100   152    0     0  21279      0 --:--:-- --:--:-- --:--:-- 76000
{
  "id": 2,
  "city": "Lyon",
  "name": "Lyon–Saint Exupéry Airport",
  "url": "https://en.wikipedia.org/wiki/Lyon%E2%80%93Saint-Exup%C3%A9ry_Airport",
  "iata": "LYS"
}
```

