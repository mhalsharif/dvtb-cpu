FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
  python git wget \
  libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler \
  libgflags-dev libgoogle-glog-dev liblmdb-dev \
  libatlas-base-dev \
  python-numpy \
  libhdf5-serial-dev \
  python-dev \
  python-opencv \
  python-pip

RUN apt-get install -y libboost-all-dev --no-install-recommends

RUN pip install --upgrade "pip < 21.0"
RUN pip install scikit-image scipy protobuf

ENV CAFFE_ROOT=/opt/caffe \
    DVTB_ROOT=/opt/dvtb

RUN mkdir $CAFFE_ROOT $DVTB_ROOT

WORKDIR $CAFFE_ROOT
RUN git clone https://github.com/BVLC/caffe.git . && \
    git remote add yosinski https://github.com/yosinski/caffe.git && \
    git fetch --all && \
    git checkout --track -b deconv-deep-vis-toolbox yosinski/deconv-deep-vis-toolbox

COPY Makefile.config .

RUN make -j4 pycaffe
RUN make -j4 all
RUN make -j4 test
RUN make -j4 runtest

RUN bash -c "echo \"export PYTHONPATH=$CAFFE_ROOT/python:\\\$PYTHONPATH\" >> /root/.bashrc"

WORKDIR $DVTB_ROOT
RUN git clone https://github.com/yosinski/deep-visualization-toolbox .

COPY settings_local.py .
