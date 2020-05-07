#!/usr/bin/python

import argparse
import subprocess
import os



def call_online_client(duration, uri, sample_rate):
	assert isinstance(sample_rate, int)
	ps = subprocess.Popen(['arecord', '-f', 'S16_LE', '-r', str(sample_rate), '-d', str(duration)], stdout=subprocess.PIPE)
	output = subprocess.check_output(('python2', 'client.py', '-r', str(sample_rate*2), '-u', str(uri), "-"), stdin=ps.stdout)
	ps.wait()
	pass


def call_client_from_file(audiofile, uri, sample_rate):
	assert isinstance(sample_rate, int)
	os.system("python2 client.py -r %d -u %s %s" % (sample_rate*2, uri, audiofile))
	pass


def main():
	parser = argparse.ArgumentParser(
						description="This script simplifies client.py by making the online decoding (from microphone) easier."\
									"Please note that you must provide a 16-bit audiofile if you are using the --audiofile option."
					  )
	parser.add_argument("--from-mic", action="store_true", default=False, 
						help="If provided then we are going to expect input from the microphone."
						     "The duration of the recording will be specified by --duration (defaults to 10 seconds).")

	parser.add_argument("-f", "--audiofile", default="", 
						help="If --from-mic is not provided then use -f or --audiofile in order to specify a WAVE file.")

	parser.add_argument("-d", "--duration", default=10, type=int,
						help="Works only if --from-mic is provided. Otherwise, it is ignored."
						     "It must be an integer. It denotes the number of seconds that the microphone will be open.")

	parser.add_argument("-ip", "--host-ip", default="192.168.1.36", dest="ip",
						help="The ip of the kaldi gstreamer server machine.")

	parser.add_argument("-r", "--sr", "--sample-rate", default=8000, choices=[8000, 16000, 32000, 48000], dest="sr",
						help="The sample rate of the audio (or the microphone input)")

	args = parser.parse_args()
	if (args.audiofile == "") and (args.from_mic is False): 
		raise argparse.ArgumentTypeError("You must provide either --from-mic or a valid WAVE file path.")

	assert os.path.exists("./client.py"), "Could not locate client.py. Aborting..."

	uri ="ws://%s:8090/client/ws/speech" %args.ip

	if args.from_mic:
		call_online_client(args.duration, uri, args.sr)
	else:
		assert os.path.exists(args.audiofile), "Audiofile could not be located: %s" %args.audiofile
		call_client_from_file(args.audiofile, uri, args.sr)



if __name__ == "__main__":
	main()
