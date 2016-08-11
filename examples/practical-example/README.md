# Working example with single docker file
This docker file automates the process described in the practial end to end example.
It is purely meant for creating a basic test system very quickly.
It creates a single Docker Image and starts the Kaldi master and a single worker. It also downloads a model. 
Due to the size of the model it take take a while to create this docker image.

#Steps to run
Build the docker image
```
docker build -t docker-kaldi-gstreamer-example:latest .
```

Run the docker image
```
docker run -itd -p 8080:80 --shm-size=256m  docker-kaldi-gstreamer-example:latest 

```

