# docker-kaldi-gstreamer-server
Dockerfile for building image for [kaldi-gstreamer-server] (https://github.com/alumae/kaldi-gstreamer-server).

Testing
-------
 
* First of all, you need to have a valid kaldi model. You can download an english model from: https://phon.ioc.ee/~tanela/tedlium_nnet_ms_sp_online.tgz. 

* Then you will need to create a valid yaml file describing your model. Some examples of valid yaml files can be found at https://github.com/alumae/kaldi-gstreamer-server.

* Put the model and the yaml file in the same directory (eg: /home/models/english). You must configure the right paths in the yaml and in the model files.

* Create a container: `docker run -it -p 9876:7171 -v /home/models/english:/opt/models/english IMAGE_ID /bin/bash`. This way, you will be able to instantiate a speech recognition service that will be exposed on port 9876 of your host.

* In the container, execute `/opt/start.sh` followed by its required arguments, e.g. `-y /opt/models/english/sample.yaml`. It will first create one master, then it will create a worker following the instructions given in the yaml file. In the end, this worker will be connected to the master.

* You can stop everything executing /opt/stop.sh inside the container. You can also stop the container using docker command line interface.



Based on
--------
* [kaldi](http://www.kaldi.org)
* [gst-kaldi-nnet2-online] (https://github.com/alumae/gst-kaldi-nnet2-online)
* [kaldi-gstreamer-server] (https://github.com/alumae/kaldi-gstreamer-server)
