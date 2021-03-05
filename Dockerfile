FROM nvidia/cuda:11.0.3-devel-ubuntu18.04
ARG THIS_UID
ARG THIS_USER

RUN ([ ! -z "${THIS_UID}" ] && [ ! -z "${THIS_USER}" ]) || { echo "THIS_UID and THIS_USER should be provided."; exit 1; }

COPY ./init-root.sh /tmp/init-root.sh
RUN chmod u+x /tmp/init-root.sh && /tmp/init-root.sh

RUN useradd -m --uid $THIS_UID -m $THIS_USER && usermod -aG sudo $THIS_USER\
 && echo "$THIS_USER:$THIS_USER" | chpasswd\
 && chsh -s /usr/bin/zsh $THIS_USER

USER $THIS_USER
WORKDIR /home/$THIS_USER
COPY --chown=$THIS_USER:$THIS_USER ./init-user.sh /tmp/init-user.sh
RUN ["/bin/bash", "-c", "/tmp/init-user.sh"]

CMD zsh

