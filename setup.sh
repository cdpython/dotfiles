#!/bin/bash

if [ "$(uname)" == "Darwin" ]; then
    # first install brew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    # uninstall vim
    brew remove vim
    # git
    brew install git
    # install tmux
    brew install tmux
    # install wget
    brew install wget
    # install python
    brew install python python3
    # install cmake
    brew install cmake
    # zsh
    brew install zsh
    # httpie
    brew install httpie
    # go 
    brew install go
    mkdir -p $HOME/go
    # ruby
    brew install ruby
    # install reattach-to-user-namespace for tmux pbcopy
    brew install reattach-to-user-namespace
    # ctags
    brew install ctags
    # neovim
    brew install neovim
    # coderay
    gem install coderay

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

    echo "[+] apt update & upgrade"
    sudo apt-get install software-properties-common
    sudo add-apt-repository ppa:neovim-ppa/stable
    sudo apt update 
    sudo apt upgrade -yq
    sudo apt remove vim -y
    sudo apt install tmux neovim zsh python-minimal wget xclip curl python3-pip python-pip httpie coderay build-essential cmake ctags -y

    # get docker
    echo "[+] dcoker & docker-compose install"
    file="/usr/bin/docker"
    if [ -f "$file" ]
    then
        echo "$file already installed."
    else
        echo "[+] install docker"
        curl -fsSL get.docker.com -o /tmp/get-docker.sh
        sudo sh /tmp/get-docker.sh
    fi

    file="/usr/local/bin/docker-compose"
    if [ -f "$file" ]
    then
        echo "$file already installed."
    else
        sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi

    # golang(no more default setting)
    #file="/usr/local/go/bin/go"
    #if [ -f "$file" ] 
    #then
    #    echo "$file already installed."
    #else
    #    echo "[+] golang install"
    #    wget https://dl.google.com/go/go1.9.2.linux-amd64.tar.gz -O /tmp/go1.9.2.linux-amd64.tar.gz
    #    sudo tar -C /usr/local -xzf /tmp/go1.9.2.linux-amd64.tar.gz
    #fi

    #if [ -d "$HOME/go" ]; 
    #then
    #    echo "GOPATH already installed."
    #else
    #    mkdir $HOME/go
    #fi

    # pip
    echo "[+] upgrade pip"
    sudo pip install --upgrade pip
    sudo pip3 install --upgrade pip

fi



# git submodule
echo "[+] git submodule update"
git submodule update --init --recursive --quiet

# oh-my-zsh install
echo "[+] install oh-my-zsh"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.dotfiles/zshrc/oh-my-zsh
git clone git://github.com/zsh-users/zsh-autosuggestions ~/.dotfiles/zshrc/oh-my-zsh/plugins/zsh-autosuggestions
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.dotfiles/zshrc/oh-my-zsh/plugins/zsh-syntax-highlighting
# fonts
echo "[+] install font"
fonts/install.sh

# virtualenv, aws-cli
echo "[+] virtual env, aws install"
if [ "$(uname)" != "Darwin" ]; then
    sudo pip install virtualenv virtualenvwrapper 
    sudo pip install neovim
    sudo pip3 install neovim
    pip install awscli --upgrade --user

else
    pip2 install virtualenv virtualenvwrapper neovim awscli
    pip3 install virtualenv virtualenvwrapper neovim awscli
fi

#fzf
echo "[+] fzf install"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


echo "[+] link"
# zsh 
echo "[+] zshrc link"
rm -rf ~/.zshrc
ln -s ~/.dotfiles/zshrc/zshrc ~/.zshrc
# vim
echo "[+] vimrc link"
mkdir ~/.config
rm -rf ~/.vim
rm -rf ~/.config/nvim
rm -rf ~/.vimrc

ln -s ~/.dotfiles/vim ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.dotfiles/vim ~/.config/nvim
# tmux setting
echo "[+] tmux.conf link"
rm -rf ~/.tmux.conf
ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
~/.dotfiles/tmux/plugins/tpm/scripts/install_plugins.sh

echo "[+] change shell"
if [ "$(uname)" == "Darwin" ]; then
    sudo sh -c 'echo /usr/local/bin/zsh >> /etc/shells'
fi
chsh -s `which zsh`


# nvm
echo "[+] nvm install"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
source ~/.nvm/nvm.sh
nvm install --lts

# vim plugin
vim +PlugInstall +qall now

# rust lang
echo "[+] rust install"
curl https://sh.rustup.rs -sSf | sh
echo "[+] fd & ripgrep install"
~/.cargo/bin/cargo install fd-find ripgrep

# run zsh
echo "[+] Finished!"
zsh