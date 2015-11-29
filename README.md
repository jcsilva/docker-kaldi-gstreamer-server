# docker-worker
Dockerfile for building kaldi online worker (gmm and nnet2) images. 

Create Image
------------

Assuming docker is already installed, simply run `docker build .`.

Test
----

* Get a kaldi model. You can download an english model from: https://phon.ioc.ee/~tanela/tedlium_nnet_ms_sp_online.tgz
* Create a container: `docker run -it IMAGE_ID /bin/bash`
* In the container, execute `/opt/start-woker.sh`. You must pass the required arguments.
* You can stop the worker simply executing `/opt/terminate-worker.sh` inside the container. You can also stop the container using docker command line interface.


Based on
--------
* [kaldi](http://www.kaldi.org)
* [gst-kaldi-nnet2-online] (https://github.com/alumae/gst-kaldi-nnet2-online)
* [kaldi-gstreamer-server] (https://github.com/alumae/kaldi-gstreamer-server)
