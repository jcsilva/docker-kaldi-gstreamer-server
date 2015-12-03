# docker-kaldi-gstreamer-server
Dockerfile for [kaldi-gstreamer-server](https://github.com/alumae/kaldi-gstreamer-server).

Synopsis
--------

This dockerfile automatically builds master and worker servers that are explained at [Full-duplex Speech-to-text System for Estonian](http://ebooks.iospress.nl/volumearticle/37996) from Tanel Alumaë and implemented by himself at https://github.com/alumae/kaldi-gstreamer-server.

Using this project you will be able to run an automatic speech recognition (ASR) server in a few minutes.

Attention
---------

The ASR server that will be set up here requires some [kaldi models](http://www.kaldi.org). In the docker image I will detail below, there are no kaldi models included.

You must have these models on your machine. You must also an yaml file describing these models. Please, check some examples [here](https://github.com/alumae/kaldi-gstreamer-server/blob/master/sample_worker.yaml), [here](https://github.com/alumae/kaldi-gstreamer-server/blob/master/estonian_worker.yaml) and [here](https://github.com/alumae/kaldi-gstreamer-server/blob/master/sample_english_nnet2.yaml) to find out how to write your own yaml files.

There are some kaldi models available for download. I have tested my setup with this [one](https://phon.ioc.ee/~tanela/tedlium_nnet_ms_sp_online.tgz), which is for English. I'm trying to build a model for Brazilian Portuguese, but until now I didn't find enough free/open resources.


How to use
----------

It's possible to use the same docker in two scenarios. You may create the master and worker on the same host machine. Or you can create just a worker and connect it to an already existing master. These two situations are explained below. 

* Instantiate master server and woker server on the same machine:

Assuming that your kaldi models are located at /home/models on your host machine, create a container (that I will call asr):

```
docker run -it -p 8080:80 -v /home/models:/opt/models --name asr jcsilva/docker-kaldi-gstreamer-server:latest /bin/bash
```

And, inside the container, start the service:

```
 /opt/start.sh -y /opt/models/nnet2.yaml
```

You will see that 2 .log files (worker.log and master.log) will be created at /opt of your containter. If everything goes ok, you will see some lines indicating that there is a woker available. In this case, you can go back to your host machine (`Ctrl+P and Ctrl+Q` on the container). Your ASR service will be listening on port 8080.

For stopping the servers, you may execute the following command inside your container:
```
 /opt/stop.sh
```

* Instantiate a woker server and connect it to a remote master:

Assuming that your kaldi models are located at /home/models on your host machine, create a container (that I will call asr):

```
docker run -it -v /home/models:/opt/models --name asr jcsilva/docker-kaldi-gstreamer-server:latest /bin/bash
```

And, inside the container, start the service:

```
/opt/start.sh -y /opt/models/nnet2.yaml -m master-server.com -p 8888
```

It instantiates a worker on your local host and connects it to a master server located at master-server.com:8888. 

You will see that a worker.log file will be created at /opt of your container. If everything goes ok, you will see some lines indicating that there is a woker avail
able.

For stopping the worker server, you may execute the following command inside your container:
```
 /opt/stop.sh
```

Testing
-------

I have used [Kõnele](http://kaljurand.github.io/K6nele/) for testing the service. It is an Android app that is freely available for downloading at Google Play.

A Javascript client is available at http://kaljurand.github.io/dictate.js/.

Credits
--------
* [kaldi](http://www.kaldi.org)
* [gst-kaldi-nnet2-online](https://github.com/alumae/gst-kaldi-nnet2-online)
* [kaldi-gstreamer-server](https://github.com/alumae/kaldi-gstreamer-server)
* [Kõnele](http://kaljurand.github.io/K6nele/)
