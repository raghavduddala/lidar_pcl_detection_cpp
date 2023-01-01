FROM ubuntu:focal-20220922

# Sets up non interactive mode when running apt install commands
ENV DEBIAN_FRONTEND=noninteractive

# Setup Locales
RUN apt update && apt install -y locales
ENV LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" LANGUAGE="en_US.UTF-8"
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen --purge $LANG && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE

# Setting up LA/Pacif   ic Time
ENV TZ=Etc/UTC

# Setting up workspace for workdir
ENV WORKSPACE="/workspace/"

RUN apt update && apt install  --no-install-recommends -y \
    build-essential \
    clang \
    cmake \
    curl \
    gcc \
    gdb \
    git \
    libpcl-dev \
    wget \
    && apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR ${WORKSPACE}
