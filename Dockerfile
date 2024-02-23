# Use the tourmaline image as a parent image, which uses the official QIIME 2 image
FROM aomlomics/tourmaline:latest

# Label information
LABEL maintainer="Carter Rollins"
LABEL description="Docker image to build the Opal server for handling Tourmaline/QIIME2 requests."

# Allow statements and log messages to immediately appear in the logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

# Update and install screen
RUN apt-get update && apt-get install -y screen

# Install production dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Generate prisma client
RUN prisma generate --generator py

# Run the web service on container startup. Here we use gunicorn with the uvicorn ASGI worker class
# We must listen on port $PORT, as per Google Cloud Run's Container runtime contract
ENV PORT 8080
# CMD exec hypercorn --bind :$PORT main:app
# CMD exec uvicorn --host 0.0.0.0 --port $PORT main:app
CMD exec gunicorn --pid app.pid --bind :$PORT --workers 1 --threads 8 --timeout 0 -k uvicorn.workers.UvicornWorker main:app
