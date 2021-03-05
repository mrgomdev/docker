#!/bin/bash
TEMP_DIR="/tmp/init"
mkdir -p $TEMP_DIR

if [ "$USER" = "root" ] || [ "$(id -u)" = "0" ] ; then
  echo "WARNING: Your are running init-user.sh in root."
  sleep 3s
fi
if ( [ "$USER" = "root" ] || [ "$(id -u)" = "0" ] ) && [ "$(logname)" != "" ] ; then
  echo "[init-user.sh] you ran this script in sudo. Restarting this script without root permission..."
  sudo -u $(logname) -H bash -c "$0"
  exit $?
fi

### zsh
if [ "$(which zsh)" = "" ] || [ "$(which zsh)" = "zsh is not found" ] ; then
  echo "[init-user.sh] zsh should be installed before init.sh."
  exit 1
fi
echo "[init-user.sh] Post installation for zsh..."
sleep 1s
#cd $TEMP_DIR && wget ftp://ftp.gnu.org/gnu/ncurses/ncurses-6.1.tar.gz && tar xf ncurses-6.1.tar.gz && cd ncurses-6.1 && ./configure --prefix=$HOME/local CXXFLAGS="-fPIC" CFLAGS="-fPIC" && make -j && make install

#cd $TEMP_DIR && wget https://www.zsh.org/pub/zsh-5.8.tar.xz
#ZSH_SRC_NAME=$HOME/packages/zsh.tar.xz
#ZSH_PACK_DIR=$HOME/packages/zsh
#ZSH_LINK="https://sourceforge.net/projects/zsh/files/latest/download"
#if [[ ! -d "$ZSH_PACK_DIR" ]]; then     echo "Creating zsh directory under packages directory";     mkdir -p "$ZSH_PACK_DIR"; fi
#if [[ ! -f $ZSH_SRC_NAME ]]; then     curl -Lo "$ZSH_SRC_NAME" "$ZSH_LINK"; fi
#tar xJvf "$ZSH_SRC_NAME" -C "$ZSH_PACK_DIR" --strip-components 1
#cd "$ZSH_PACK_DIR" && ./configure --prefix="$HOME/local"     CPPFLAGS="-I$HOME/local/include"     LDFLAGS="-L$HOME/local/lib"
#make -j && make install

curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | zsh || true

#echo "export PATH=\$HOME/local/bin:\$PATH" >> $HOME/.bash_profile
#source $HOME/.bash_profile

cd $TEMP_DIR && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && sed -i 's/plugins=(/plugins=(zsh-syntax-highlighting /' $HOME/.zshrc

cd $TEMP_DIR && git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts && ./install.sh && sed -i 's/ZSH_THEME=.*/ZSH_THEME=\"agnoster\"/' $HOME/.zshrc

HOME_BIN=$HOME/.local/bin
mkdir -p $HOME_BIN
echo "export PATH=\"$HOME_BIN:\$PATH\"" >> $HOME/.zshrc
echo "export PATH=\"$HOME_BIN:\$PATH\"" >> $HOME/.bashrc

echo -e "#\!/usr/bin/bash\nexport LS_COLORS=\"rs=0:di=01;33:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:\"" > $HOME_BIN/dir_colors.sh
chmod +x $HOME_BIN/dir_colors.sh
echo -e "source $HOME_BIN/dir_colors.sh" >> $HOME/.zshrc
echo -e "source $HOME_BIN/dir_colors.sh" >> $HOME/.bashrc
echo -e "prompt_context() {\n  prompt_segment black default \"%n@%m\"\n}" >> $HOME/.zshrc

echo "[init-user.sh] Showing essential parts of $HOME/.zshrc"
cat $HOME/.zshrc | sed '/^[ ]*#.*/d' | sed '/^$/d'
echo "[init-user.sh] End of $HOME/.zshrc"

### conda
echo "[init-user.sh] Setting base conda..."
sleep 1s
cd $TEMP_DIR && wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && chmod +x $TEMP_DIR/Miniconda3-latest-Linux-x86_64.sh && $TEMP_DIR/Miniconda3-latest-Linux-x86_64.sh -b && $HOME/miniconda3/bin/conda init zsh bash
$HOME/miniconda3/bin/conda install -y python=3.7
$HOME/miniconda3/bin/conda install -y msgpack-python msgpack-numpy psutil numpy pyzmq termcolor tabulate lmdb 
$HOME/miniconda3/bin/pip install tensorpack==0.11 python-prctl
