FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive
ENV CRAN_MIRROR http://cran.rstudio.com/

RUN echo "deb $CRAN_MIRROR/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

RUN apt-get update; apt-get -y upgrade

RUN apt-get install -y sudo r-base r-base-dev

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
WORKDIR /home/developer

RUN echo "options(repos=structure(c(CRAN=\"$CRAN_MIRROR\")))" > $HOME/.Rprofile

CMD ["R", "--vanilla"]
