# To run using Docker:

Build the image and run the image in a container using 
```bash
docker build -t opalserver .; docker run -p 8080:8080 --name opalserver opalserver
```
This will open a web server at `localhost:8080`.

To open the container in VSCode, open the Command Pallette `ctrl + shift + p` and run `Dev Containers: Attach to Running Container` (this requires the Dev Containers extension).

To delete the container and image, use
```bash
docker rm opalserver; docker rmi opalserver
```

# Commands for running locally

To install all dependencies, run the command
```bash
pip install -r requirements.txt
```
To generate a new Prisma schema, run the command
```bash
prisma generate --generator py
```