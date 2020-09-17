FROM debian:buster-slim

RUN apt-get -y update && apt-get install -y \
    build-essential \
    curl \
    gfortran \
    git \
    libatlas-base-dev \
    libfreetype6-dev \
    pkg-config \
    python3-dev \
    python3-pip

RUN mkdir -p /opt && \
    curl -L -o /opt/hdf5.tgz "https://www.hdfgroup.org/package/hdf5-1-12-0-tar-gz/?wpdmdl=14582&refresh=5f62b268a1c171600303720" && \
    tar zxvf /opt/hdf5.tgz -C /opt/ && \
    cd /opt/hdf5-* && \
    ./configure --prefix=/usr/local/hdf5 && \
    make -j$(nproc) && \
    make check
RUN cd /opt/hdf5-* && \
    make install && \
    make check-install

RUN git clone https://github.com/enigmampc/catalyst.git /app && \
    cd /app && \
    pip3 install virtualenv && \
    virtualenv catalyst-venv
RUN cd /app && \
    /app/catalyst-venv/bin/python -m pip install --upgrade pip && \
    source ./catalyst-venv/bin/activate && \
    pip3 install setuptools==45 && \
    pip install numpy tables
RUN cd /app && \    
    HDF5_DIR=/usr/local/hdf5 pip install enigma-catalyst matplotlib