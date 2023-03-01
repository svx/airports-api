# Based on https://testdriven.io/blog/fastapi-docker-traefik/
FROM python:3.11.1-slim

ENV APP_HOME=/src
ENV APP_USER=appuser

# Create user and app directory
RUN groupadd -r $APP_USER && \
    useradd -r -g $APP_USER -d $APP_HOME -s /sbin/nologin -c "Docker image user" $APP_USER && \
    mkdir $APP_HOME && \
    chown -R $APP_USER:$APP_USER $APP_HOME

USER $APP_USER

# Set work directory
WORKDIR $APP_HOME

# Set env variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY --chown=$APP_USER:$APP_USER requirements.txt .

RUN python3 -m venv env && \
    ./env/bin/pip install --no-cache-dir -r requirements.txt

# Copy project
COPY --chown=$APP_USER:$APP_USER app/ app

# Use a healthcheck,
# So Docker knows if the API is still running ok or needs to be restarted
HEALTHCHECK --interval=21s --timeout=3s --start-period=10s CMD curl --fail http://localhost:8080/health || exit 1

# Start FastAPI
CMD ["./env/bin/uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
#ENTRYPOINT [ "bash" ]