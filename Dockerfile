FROM nvidia/cuda:11.0.3-devel-ubuntu18.04
ARG THIS_UID
ARG THIS_UNAME

RUN ([ ! -z "${THIS_UID}" ] && [ ! -z "${THIS_UNAME}" ]) || { echo "THIS_UID and THIS_UNAME should be provided."; exit 1; }

RUN apt-get update && apt-get -y upgrade && apt-get -y install htop vim openssh-server wget build-essential sudo curl zsh git language-pack-en libcap-dev && update-locale

RUN useradd -m --uid $THIS_UID -m $THIS_UNAME && usermod -aG sudo $THIS_UNAME
RUN echo "$THIS_UNAME:$THIS_UNAME" | chpasswd
RUN chsh -s /usr/bin/zsh $THIS_UNAME

COPY --chown=$THIS_UNAME:$THIS_UNAME ./init.sh /home/$THIS_UNAME/init.sh
USER $THIS_UNAME
WORKDIR /home/$THIS_UNAME
RUN ["/bin/bash", "-c", "/home/$THIS_UNAME/init.sh"]

CMD zsh

