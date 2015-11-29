FROM debian:8
MAINTAINER Eduardo Silva <zedudu@gmail.com>

RUN apt-get update && apt-get install -y  \
    g++ \
    zlib1g-dev \
    make \
    automake \
    libtool-bin \
    git \
    autoconf \
    subversion \
    libatlas3-base \
    bzip2 \
    wget \
    python2.7 \
    python-pip \
    python-yaml \
    python-simplejson \
    python-gi \
    libgstreamer1.0-dev \
    gstreamer1.0-plugins-good \
    gstreamer1.0-tools \
    gstreamer1.0-pulseaudio \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-ugly  \
    libgstreamer1.0-dev

RUN pip install ws4py==0.3.2 && pip install tornado
RUN ln -s /usr/bin/python2.7 /usr/bin/python ; ln -s -f bash /bin/sh
RUN echo "/usr/local/lib" >> /etc/ld.so.conf && ldconfig


RUN cd /opt && \
    git clone https://github.com/kaldi-asr/kaldi && \
    cd /opt/kaldi/tools && \
    make && \
    ./install_portaudio.sh && \
    cd /opt/kaldi/src && ./configure --shared && \
    sed -i '/-g # -O0 -DKALDI_PARANOID/c\-O3 -DNDEBUG' kaldi.mk && \
    make depend && make && \
    cd /opt/kaldi/src/online && make depend && make && \
    cd /opt/kaldi/src/gst-plugin && make depend && make && \
    rm -rf /opt/kaldi/.git && \
    rm -rf /opt/kaldi/egs/ /opt/kaldi/windows/ /opt/kaldi/misc/ && \
    find /opt/kaldi/src/ -type f -not -name '*.so' -delete && \
    find /opt/kaldi/tools/ -type f -not -name '*.so' -delete

RUN cd /opt && wget http://www.digip.org/jansson/releases/jansson-2.7.tar.bz2 && \
    bunzip2 -c jansson-2.7.tar.bz2 | tar xf -  && \
    cd jansson-2.7 && \
    ./configure && make && make check &&  make install && \
    rm /opt/jansson-2.7.tar.bz2 && rm -rf /opt/jansson-2.7

RUN cd /opt && \
    git clone https://github.com/alumae/gst-kaldi-nnet2-online.git && \
    cd /opt/gst-kaldi-nnet2-online/src && \
    sed -i '/KALDI_ROOT?=\/home\/tanel\/tools\/kaldi-trunk/c\KALDI_ROOT?=\/opt\/kaldi' Makefile && \
    make depend && make && \
    rm -rf /opt/gst-kaldi-nnet2-online/.git/ && \
    find /opt/gst-kaldi-nnet2-online/src/ -type f -not -name '*.so' -delete

RUN cd /opt && git clone https://github.com/alumae/kaldi-gstreamer-server.git && \
    rm -rf /opt/kaldi-gstreamer-server/.git/ && \
    rm -rf /opt/kaldi-gstreamer-server/test/

RUN apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN echo "#!/bin/bash" > /opt/start-worker.sh  && \
    echo "[ \$# -eq 0 ] && { echo \"Usage: \$0 master_address yaml_file\"; echo \"Ex: ./start-worker.sh ws://localhost/worker/ws/speech sample.yaml\"; exit 1; }" >> /opt/start-worker.sh && \
    echo "export GST_PLUGIN_PATH=/opt/gst-kaldi-nnet2-online/src/:/opt/kaldi/src/gst-plugin/" >> /opt/start-worker.sh && \
    echo "python /opt/kaldi-gstreamer-server/kaldigstserver/worker.py -u \$1 -c \$2 &" >> /opt/start-worker.sh && \
    chmod +x /opt/start-worker.sh

RUN echo "#!/bin/bash" > /opt/terminate-worker.sh  && \
    echo "ps axf | grep worker.py | grep -v grep | awk '{print \"kill -15 \" \$1}' | sh" >> /opt/terminate-worker.sh && \
    chmod +x /opt/terminate-worker.sh
