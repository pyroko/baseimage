#########################################################
# pyrocko-nest
#########################################################

FROM debian:stable

RUN apt-get update -y
RUN apt-get upgrade -y

# env requirements
RUN apt-get install -y python3-pip
RUN pip3 install twine
RUN apt-get install -y wget

# linter requirements
RUN pip3 install flake8

# build requirements
RUN apt-get install -y make git
RUN apt-get install -y python3-dev python3-setuptools python3-numpy-dev

# testing requirements
RUN apt-get install -y xvfb libgles2-mesa
RUN apt-get install -y python3-coverage python3-nose

# base runtime requirements
RUN apt-get install -y \
        python3-numpy python3-scipy python3-matplotlib \
        python3-requests python3-future \
        python3-yaml python3-progressbar

# gui runtime requirements
RUN apt-get install -y \
        python3-pyqt5 python3-pyqt5.qtopengl python3-pyqt5.qtsvg \
        python3-pyqt5.qtwebengine python3-pyqt5.qtwebkit

# optional runtime requirements
RUN apt-get install -y \
        python3-jinja2 python3-pybtex

# additional runtime requirements for gmt
RUN apt-get install -y \
        gmt gmt-gshhg poppler-utils imagemagick

# additional runtime requirements for fomosto backends
RUN apt-get install -y autoconf gfortran
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qseis.git \
    && cd fomosto-qseis && autoreconf -i && ./configure && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-psgrn-pscmp.git \
    && cd fomosto-psgrn-pscmp && autoreconf -i && ./configure && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qseis2d.git \
    && cd fomosto-qseis2d && autoreconf -i && ./configure && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qssp.git \
    && cd fomosto-qssp && autoreconf -i && ./configure && make && make install
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/fomosto-qssp2017.git \
    && cd fomosto-qssp2017 && autoreconf -i && ./configure && make && make install

#########################################################
# pyrocko
#########################################################
WORKDIR /src
RUN git clone https://git.pyrocko.org/pyrocko/pyrocko.git \
    && cd pyrocko && python3 install.py user --yes
#########################################################
#fat-nest
#########################################################

RUN wget -r http://data.pyrocko.org/testing/pyrocko/ -nv --no-parent -nH --cut-dirs=2 -P pyrocko-test-data

#COPY pyrocko-test-data /pyrocko-test-data

#########################################################
# docs
#########################################################

RUN apt-get update -y
RUN apt-get upgrade -y

# env requirements
#RUN apt-get install -y python3-pip 
RUN apt-get install -y python3-pip nemo terminator nano gedit dbus-x11

# build requirements
RUN apt-get install -y make git
RUN apt-get install -y python3-dev python3-setuptools python3-numpy-dev

# docs requirements
RUN apt-get install -y \
    texlive-fonts-recommended texlive-latex-extra \
    texlive-latex-recommended
RUN pip3 install sphinx git+https://git.pyrocko.org/pyrocko/sphinx-sleekcat-theme.git

# base runtime requirements
RUN apt-get install -y \
        python3-numpy python3-scipy python3-matplotlib \
        python3-requests python3-future \
        python3-yaml python3-progressbar 

# gui runtime requirements
RUN apt-get install -y \
        python3-pyqt5 python3-pyqt5.qtopengl python3-pyqt5.qtsvg \
        python3-pyqt5.qtwebengine python3-pyqt5.qtwebkit
#########################################################
#utils
#########################################################

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y rsync git python3-pip xvfb libgles2-mesa libfontconfig1 libxrender1 libxkbcommon-x11-0 python3-requests

#########################################################
# WEB Browser Environemnt - firefox
#########################################################

# Set Browser Environemnt.
RUN \
    echo "deb http://deb.debian.org/debian/ unstable main contrib non-free" >> /etc/apt/sources.list.d/debian.list
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends firefox

#########################################################
# JUPYTER Environemnt
#########################################################
#RUN apt-get install -y add-apt-repository
#RUN add-apt-repository ppa:mozillateam/ppa
RUN apt-get update -y
RUN apt-get upgrade -y
#RUN apt-get install -y firefox jupyter
RUN apt-get install -y jupyter
#########################################################
#adduser
#########################################################
RUN groupadd -r user && useradd -r -g user user
#RUN useradd -ms /bin/bash user
USER user
WORKDIR /home/user