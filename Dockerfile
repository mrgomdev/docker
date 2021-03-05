FROM nvidia/cuda:11.0.3-devel-ubuntu18.04
ARG THIS_UID
ARG THIS_UNAME

RUN ([ ! -z "${THIS_UID}" ] && [ ! -z "${THIS_UNAME}" ]) || { echo "THIS_UID and THIS_UNAME should be provided."; exit 1; }

COPY ./init-root.sh /tmp/init-root.sh
RUN chmod u+x /tmp/init-root.sh && /tmp/init-root.sh

RUN useradd -m --uid $THIS_UID -m $THIS_UNAME && usermod -aG sudo $THIS_UNAME
RUN echo "$THIS_UNAME:$THIS_UNAME" | chpasswd
RUN chsh -s /usr/bin/zsh $THIS_UNAME

USER $THIS_UNAME
WORKDIR /home/$THIS_UNAME
COPY --chown=$THIS_UNAME:$THIS_UNAME ./init-user.sh /tmp/init-user.sh
RUN ["/bin/bash", "-c", "/tmp/init-user.sh"]

CMD zsh

