# docker-kaldi-gstreamer-server
Dockerfile for building image for [kaldi-gstreamer-server] (https://github.com/alumae/kaldi-gstreamer-server).

Create Image
------------

Assuming docker is already installed, simply run `docker build .`

Running master
--------------

* `docker run -it -p 8080:80 IMAGE_ID /bin/bash python kaldigstserver/master_server.py`

Running worker
--------------

* Get a kaldi model. You can download an english model from: https://phon.ioc.ee/~tanela/tedlium_nnet_ms_sp_online.tgz. I'll assume you have a valid nnet2 model located somewhere in your machine (e.g. `/home/models/english`) and also a valid yaml file (located at the same directory).
* If you don't know how to create a valid yaml file, you can check some examples here https://github.com/alumae/kaldi-gstreamer-server. These examples are also included in the directory `/opt/kaldi-gstreamer-server` of the container that will be created.
* Create a container: `docker run -it -v /home/models/english:/opt/models/english IMAGE_ID /bin/bash`
* In the container, execute `/opt/start-woker.sh` followed by its required arguments, e.g. `ws://localhost:8080/woker/ws/speech /opt/models/english/tedlium_english_nnet2.yaml`.
* You can stop the worker simply executing `/opt/terminate-worker.sh` inside the container. You can also stop the container using docker command line interface.


Based on
--------
* [kaldi](http://www.kaldi.org)
* [gst-kaldi-nnet2-online] (https://github.com/alumae/gst-kaldi-nnet2-online)
* [kaldi-gstreamer-server] (https://github.com/alumae/kaldi-gstreamer-server)
