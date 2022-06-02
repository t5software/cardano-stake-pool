# Installing cardano-node and cardano-cli from source
# https://developers.cardano.org/docs/get-started/installing-cardano-node/

# Installing Operating System dependencies
sudo yum update -y
sudo yum install git gcc gcc-c++ tmux gmp-devel make tar xz wget zlib-devel libtool autoconf jq -y
sudo yum install systemd-devel ncurses-devel ncurses-compat-libs -y
sudo yum install g++ realpath xz-utils

# Installing GHC and Cabal
# USER_INPUT
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

source ~/.bashrc
ghcup --version

# recommended version could change
# HARDCODE
ghcup install ghc 8.10.7
ghcup set ghc 8.10.7

# HARDCODE
ghcup install cabal 3.6.2.0
ghcup set cabal 3.6.2.0

ghc --version
cabal --version

# Downloading & Compiling
mkdir -p $HOME/cardano-src
cd $HOME/cardano-src

# libsodium
git clone https://github.com/input-output-hk/libsodium
cd libsodium
# HARDCODE
git checkout 66f017f1
./autogen.sh
./configure
make
sudo make install

# add to .bashrc
echo -e '\nexport LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"' >> ~/.bashrc
echo -e '\nexport PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"' >> ~/.bashrc

source ~/.bashrc

# download, compile, install cardano-node and cardano-cli
cd ~/cardano-src

# download the cardano-node repository
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git fetch --all --recurse-submodules --tags

# switch the repository to the latest tagged commit
# read release notes https://github.com/input-output-hk/cardano-node/releases
git checkout $(curl -s https://api.github.com/repos/input-output-hk/cardano-node/releases/latest | jq -r .tag_name)

# Configuring the build options
# HARDCODE
cabal configure --with-compiler=ghc-8.10.7

# Building and installing the node
cabal build cardano-node cardano-cli

# install the newly built node and CLI commands to the $HOME/.local/bin directory
mkdir -p $HOME/.local/bin
cp -p "$(./scripts/bin-path.sh cardano-node)" $HOME/.local/bin/
cp -p "$(./scripts/bin-path.sh cardano-cli)" $HOME/.local/bin/

echo -e '\nexport PATH="$HOME/.local/bin/:$PATH"' >> ~/.bashrc
source ~/.bashrc

cardano-cli --version
cardano-node --version
