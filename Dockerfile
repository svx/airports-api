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
#COPY requirements.txt .
#RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY --chown=$APP_USER:$APP_USER app/ app

# Start FastAPI
CMD ["./env/bin/uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
#ENTRYPOINT [ "bash" ]