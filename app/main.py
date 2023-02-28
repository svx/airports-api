from fastapi import FastAPI, APIRouter


PLANETS = [
    {
        "id": 1,
        "name": "Pluto",
        "description": "Pluto is a planet in the Kuiper belt, a ring of bodies beyond the orbit of Neptune.",
        "url": "https://en.wikipedia.org/wiki/Pluto",
    },
    {
        "id": 2,
        "name": "Mars",
        "description": "Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System",
        "url": "https://en.wikipedia.org/wiki/Mars",
    },
    {
        "id": 3,
        "name": "Venus",
        "description": "Venus is the second planet from the Sun. It is sometimes called Earth's sister or twin planet",
        "url": "https://en.wikipedia.org/wiki/Venus",
    },
]

description = """
This API helps you do awesome stuff. 🚀

This is just an example API to learn more about Traefik Hub.

## Planets

List some planets:

- Pluto
- Mars
- Venus
"""

app = FastAPI(
    title="Planets API",
    description=description,
    version="0.0.1",
    terms_of_service="http://example.com/terms/",
    contact={
        "name": "Deadpoolio the Amazing",
        "url": "http://x-force.example.com/contact/",
        "email": "dp@x-force.example.com",
    },
    license_info={
        "name": "Apache 2.0",
        "url": "https://www.apache.org/licenses/LICENSE-2.0.html",
    },
    openapi_url="/openapi.json")

api_router = APIRouter()


@api_router.get("/", summary="Welcome", status_code=200)
def root() -> dict:
    """
    Receive root
    """
    return {"msg": "Welcome, to the world of planets!"}


# New addition, path parameter
# https://fastapi.tiangolo.com/tutorial/path-params/
@api_router.get("/planets/{planet_id}", summary="Receive planet by ID", status_code=200)
def fetch_planet(*, planet_id: int) -> dict:
    """
    Fetch a single planet by ID
    """

    result = [planet for planet in PLANETS if planet["id"] == planet_id]
    if result:
        return result[0]


@api_router.get('/healthcheck', summary="Check health", status_code=200)
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
