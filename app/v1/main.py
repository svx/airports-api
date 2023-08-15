from fastapi import FastAPI, APIRouter
from fastapi.openapi.models import Server
from fastapi.openapi.utils import get_openapi

tags_metadata = [
    {
        "name": "Airports",
        "description": "General info about airports. ",
    },
    {
        "name": "Utils",
        "description": "API Utils, such as the health endpoint.",
    },
    {
        "name": "About",
        "description": "About this API.",
    },
]

AIRPORTS = [
    {
        "id": 1,
        "city": "Amsterdam",
        "name": "Schiphol Airport",
        "url": "https://en.wikipedia.org/wiki/Amsterdam_Airport_Schiphol",
        "iata": "AMS"
    },
    {
        "id": 2,
        "city": "Lyon",
        "name": "Lyon–Saint Exupéry Airport",
        "url": "https://en.wikipedia.org/wiki/Lyon%E2%80%93Saint-Exup%C3%A9ry_Airport",
        "iata": "LYS"
    },
    {
        "id": 3,
        "city": "Reykjavík",
        "name": "Keflavík International Airport",
        "url": "https://en.wikipedia.org/wiki/Keflav%C3%ADk_International_Airport",
        "iata": "KEF"
    },
]

description = """
![Logo](https://raw.githubusercontent.com/traefik-workshops/hub-tutorials/master/assets/traefik-airelines-logo.png)

## Overview

This API can be used to get vital information on major international airports.

- Name of the airport
- City or the airport

## Usage

Retrieve a list of all airports by sending a `GET` request to `/airports`.

```shell
curl --request GET \
--url https://api.traefik-airlines/v1/airports/airports \
--header 'Accept: application/json'
```

If you want to request information on a certain airport use the airport `ID`.

```shell
curl --request GET \
--url https://api.traefik-airlines/v1/airports/airports/{ID} \
--header 'Accept: application/json'
```

### Response codes

If the status returned is in the `200` range, it indicates that the request was fulfilled successfully and that no error was encountered.

Return codes in the `400` range indicate that there was an issue with the request that was sent.

### Versioning

This API uses semantic versioning to ensure that your client doesn't break.  
The version is declared in the URL so that you can lock to a specific one by prefix the URL.

When the version declared in the URL is not supported, you will receive a 400 response.


This API helps you do awesome travel stuff. 🚀


List some airports:

- Amsterdam
- Lyon
- Reykjavík
"""

app = FastAPI(
    title="Airports API",
    description=description,
    openapi_version="3.0.3",
    version="1.0.0",
    servers=[
        {
            "url": "http://localhost:8000",
            "description": "Development Server"
        },
        {
            "url": "https://api.traefik-airlines/v1/airports",
            "description": "Production Server",
        }
    ],
    openapi_tags=tags_metadata,
    terms_of_service="https://dev.traefik-airlines.io/tos",
    contact={
        "name": "Traefik Airlines API Team",
        "url": "https://dev.traefik-airlines.io/support",
        "email": "api@traefik-airlines.io",
    },
    license_info={
        "name": "Apache 2.0",
        "url": "https://www.apache.org/licenses/LICENSE-2.0.html",
    },
    openapi_url="/openapi.json")

api_router = APIRouter()

def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema
    openapi_schema = get_openapi(
        title="Airports API",
        openapi_version="3.0.3",
        version="1.0.0",
        summary="",
        description=description,
        routes=app.routes,
    )
    openapi_schema["info"]["x-logo"] = {
        "url": ""
    }
    app.openapi_schema = openapi_schema
    return app.openapi_schema


app.openapi = custom_openapi


@api_router.get("/", name="Index", summary="Welcome", description="Welcome message", status_code=200, tags=["About"])
def root() -> dict:
    """
    Receive root
    """
    return {"msg": "Welcome, to the Airports API version 1.0.0!"}

@api_router.get("/airports/", summary="List all airports", description="Overview of all airports supported by this API.", tags=["Airports"])
async def read_item(skip: int = 0, limit: int = 10):
    return AIRPORTS[skip : skip + limit]


# New addition, path parameter
# https://fastapi.tiangolo.com/tutorial/path-params/
@api_router.get("/airports/{airport_id}", summary="Receive airport by ID", status_code=200, tags=["Airports"])
def fetch_airport(*, airport_id: int) -> dict:
    """
    Fetch a single airport by ID
    """

    result = [airport for airport in AIRPORTS if airport["id"] == airport_id]
    if result:
        return result[0]

@api_router.get('/health', summary="Check health", description="Check service status", status_code=200, tags=["Utils"])
def perform_healthcheck():
    '''
    Simple route for the GitHub Actions to healthcheck on.
    More info is available at:
    https://github.com/akhileshns/heroku-deploy#health-check
    It basically sends a GET request to the route & hopes to get a "200"
    response code. Failing to return a 200 response code just enables
    the GitHub Actions to rollback to the last version the project was
    found in a "working condition". It acts as a last line of defense in
    case something goes south.
    Additionally, it also returns a JSON response in the form of:
    {
        'healtcheck': 'Everything OK!'
    }
    '''
    return {'healthcheck': 'Everything is OK!'}

app.include_router(api_router)


# if __name__ == "__main__":
#     # Use this for debugging purposes only
#     import uvicorn

#     uvicorn.run(app, host="0.0.0.0", port=8001, log_level="debug")
