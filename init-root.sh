#!/bin/bash

if [ "$(id -u)" != "0" ] ; then
  echo "init-sudo.sh only run in root."
  echo "Trying to restart with sudo..."
  sudo $0 $*
  exit $?
fi

apt-get update
apt-get -y upgrade
apt-get -y install htop vim openssh-server wget build-essential sudo curl zsh git language-pack-en libcap-dev
update-locale

