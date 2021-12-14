FROM nvidia/cuda:11.2.2-devel-ubuntu20.04

MAINTAINER Rafael Palomar <rafael.palomar@ous-research.no>

# This avoids installation prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install building tools
RUN apt-get update &&\
    apt-get install -y\
    gcc-9\
    build-essential\
    cmake

# Copy all files except for the build directory (build)
RUN mkdir /xgboost && mkdir /xgboost/build
COPY . /xgboost/

#Build xgboost
WORKDIR /xgboost/build
RUN cmake -DUSE_CUDA=ON -DCMAKE_BUILD_TYPE="Release" -DBUILD_WITH_CUDA_CUB=ON ../ &&\
    make &&\
    make install

#Build xgboos python package
WORKDIR /xgboost/python-package
RUN python setup.py install

# Install python dependencies
RUN apt-get install -y\
    python3\
    python-is-python3\
    python3-numpy\
    python3-pandas
