#!/bin/bash
# simple setup
exec bash
mkdir "$HOME/tmp";cd "$HOME/tmp"
curl -sS -o prereqs.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/prereqs.sh
chmod 755 prereqs.sh
# the line below still needs user interaction
NEEDRESTART_SUSPEND=true ./prereqs.sh
exec bash

# extra arm steps
NEEDRESTART_SUSPEND=true sudo apt install -y llvm-13
NEEDRESTART_SUSPEND=true sudo apt install -y clang-13 libnuma-dev
sudo ln -s /usr/bin/llvm-config-13 /usr/bin/llvm-config
sudo ln -s /usr/bin/opt-13 /usr/bin/opt
sudo ln -s /usr/bin/llc-13 /usr/bin/llc
sudo ln -s /usr/bin/clang-13 /usr/bin/clang

# clone cardano-node
cd ~/git
git clone https://github.com/input-output-hk/cardano-node
cd cardano-node

# build
git fetch --tags --all
git pull
# Replace tag against checkout if you do not want to build the latest released version
git checkout $(curl -s https://api.github.com/repos/input-output-hk/cardano-node/releases/latest | jq -r .tag_name)

echo BUILD-ALL
exec bash
$CNODE_HOME/scripts/cabal-build-all.sh
exec bash

cardano-cli version
cardano-node version
