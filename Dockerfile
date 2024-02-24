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
ARG mode
COPY docker/build${mode}.sh docker/build.sh
CMD exec bash docker/build.sh
