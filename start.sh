#!/bin/bash

MASTER="localhost"
PORT=80

usage(){
  echo "Creates a worker and connects it to a master.";
  echo "If the master address is not given, a master will be created at localhost:80";
  echo "Usage: $0 -y yaml_file [-m master address] [-p port number]";
}

while getopts "h?m:p:y:" opt; do
    case "$opt" in
    h|\?)
        usage
        exit 0
        ;;
    m)  MASTER=$OPTARG
        ;;
    p)  PORT=$OPTARG
        ;;
    y)  YAML=$OPTARG
        ;;
    esac
done

#yaml file must be specified
if [ -z "$YAML" ] || [ ! -f "$YAML" ] ; then
  usage;
  exit 1;
fi;

trap /opt/stop.sh SIGINT SIGTERM SIGHUP

if [ "$MASTER" == "localhost" ] ; then
  # start a local master
  (python /opt/kaldi-gstreamer-server/kaldigstserver/master_server.py --port=$PORT | while read line; do echo "[master] $line"; done) &
fi

#start worker and connect it to the master
export GST_PLUGIN_PATH=/opt/gst-kaldi-nnet2-online/src/:/opt/kaldi/src/gst-plugin/

python /opt/kaldi-gstreamer-server/kaldigstserver/worker.py -c $YAML -u ws://$MASTER:$PORT/worker/ws/speech | while read line; do echo "[worker] $line"; done
