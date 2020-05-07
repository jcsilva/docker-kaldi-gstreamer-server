#!/bin/bash


from_mic=false
duration=10  # in seconds
host_ip=192.168.1.36
sample_rate=8000
audiofile=

if [ $# -lt 1 ] ; then
	echo "Usage: $0 [--from-mic || --audiofile audiofile_path] [--duration=DURATION] [--host-ip=HOST-IP] [--sr=SAMPLE-RATE]"
	echo "The --duration option is only valid if --from-mic is provided as the first argument."
	echo
	echo "E.g. : $0 --from-mic --duration=5"
	echo "The above example would record from the microphone for 5 seconds. Default recording time is 10 seconds."
	echo
	echo "E.g. : $0 /home/user/Desktop/recordings/rec001.wav --host-ip=192.168.1.12 --sr=16000"
	echo "The above example would transcribe the rec001.wav audio file. The socket conection will be made with "
	echo "the ip 192.168.1.12 and the sample rate of the rec001.wav file has to be 16000Hz."
	echo
	exit 1

fi

if [ ! -f ./client.py ] ; then
	echo "./client.py does not exist. Aborting..."
	echo
	exit 1
fi


if [ $# -ge 1 ] ; then
	for i in "$@" ; do
		case $i in
		    --from-mic)
		    from_mic=true
		    shift # past argument with no value
		    ;;
		    -f=*|--audiofile=*)
			audiofile="${i#*=}"
			shift # past argument=value
			;;
		    -d=*|--duration=*)
		    duration="${i#*=}"
		    shift # past argument=value
		    ;;
		    -r=*|--sr=*)
		    sample_rate="${i#*=}"
		    shift # past argument=value
		    ;;
		    -ip=*|--host-ip=*)
		    host_ip="${i#*=}"
		    shift # past argument=value
		    ;;
		    *)
		          # unknown option
		    ;;
		esac
	done
fi

echo "AUDIOFILE: $audiofile"


# uri="ws://$host_ip:8080/client/ws/speech"
uri="ws://pobucastt.azurewebsites.net/client/ws/speech"
bytes_per_sec=$(($sample_rate * 2))  # Two times the sample rate since we expect 16-bit audio.


if [ $from_mic = true ] ; then
	arecord -f S16_LE -r $sample_rate -d $duration | python2 client.py -r $bytes_per_sec -u $uri -
else
	if [ ! -f $audiofile ] ; then
		echo "The audio file provided could not be located: $audiofile"
		echo "Make sure it exists. Aborting..."
		echo
		exit 1
	fi
	python2 client.py -u $uri -r $bytes_per_sec $audiofile 
fi


exit 0