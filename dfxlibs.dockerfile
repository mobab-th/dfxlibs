FROM ubuntu:jammy
LABEL maintainer="mobab-th"

# Create container with:
# podman build -f dfxlibs.dockerfile -t dfxlibs .
# Run dfxlibs :
# podman run --rm -v /data/:/evidences/ -v /cases/:/cases/ dfxlibs Parameter


ENV DEBIAN_FRONTEND=noninteractive

# Combining the apt-get commands into a single run reduces the size of the resulting image.
# The apt-get installations below are interdependent and need to be done in sequence.
RUN apt-get -y update && \
    apt-get -y install apt-transport-https apt-utils && \
    apt-get -y install libterm-readline-gnu-perl software-properties-common && \
    apt-get -y install locales python3-pip-whl python3-pip && \
    apt-get -y install screen mc git && \
    apt-get -y upgrade
RUN apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir libewf-python python-dateutil && \
    pip3 install --no-cache-dir libqcow-python libvmdk-python libvhdi-python && \
    pip3 install --no-cache-dir pytsk3 python-registry python-evtx && \
    pip3 install --no-cache-dir lxml XlsxWriter py-tlsh && \
    pip3 install --no-cache-dir python-magic libvshadow-python libscca-python && \
    pip3 install --no-cache-dir libbde-python libevtx-python pycryptodome && \
    pip3 install --no-cache-dir signify xmltodict lnkparse3

WORKDIR /tmp
RUN git clone https://github.com/Markus-D-M/dfxlibs.git
WORKDIR /tmp/dfxlibs
RUN python3 setup.py build
RUN python3 setup.py install

RUN python3 -m pip cache purge

# Set terminal to UTF-8 by default
RUN locale-gen de_DE.UTF-8 && update-locale LANG=de_DE.UTF-8 LC_ALL=de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LC_ALL de_DE.UTF-8


WORKDIR /cases
ENTRYPOINT ["/usr/local/bin/dfxlibs"]
