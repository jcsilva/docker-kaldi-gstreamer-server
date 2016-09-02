# Working example with single docker file
This docker file automates the process described in the practial end to end example.
It is purely meant for creating a basic test system very quickly.
It creates a single Docker Image and starts the Kaldi master and a single worker. It also downloads a model. 
Due to the size of the model it may take a while to build this docker image.

# Steps to run
## Build the docker image
```
docker build -t docker-kaldi-gstreamer-example:latest .
```

## Run the docker image:
```
docker run -itd -p 8080:80 --shm-size=256m  docker-kaldi-gstreamer-example:latest 

```

## Test the install
On your host machine, download a client example and test your setup with a given audio:
```
wget https://raw.githubusercontent.com/alumae/kaldi-gstreamer-server/master/kaldigstserver/client.py -P /tmp
wget https://raw.githubusercontent.com/alumae/kaldi-gstreamer-server/master/test/data/bill_gates-TED.mp3 -P /tmp
python /tmp/client.py -u ws://localhost:8080/client/ws/speech -r 8192 /tmp/bill_gates-TED.mp3
```
