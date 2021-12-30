#!/usr/bin/env bash

set -x

# Note: this doesn't do required path settings as they're in my bashrc already

## Compilers and interpreters

# pyenv + system libraries for building python
if [ ! -d ~/.pyenv ]; then
	 git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi
cd ~/.pyenv && src/configure && make -C src && cd ~
sudo apt-get update
sudo apt-get install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
pyenv install 3.9.9
pyenv install 3.10.1
pyenv global 3.9.9 3.10.1
pip install pip setuptools wheel --upgrade

# rust compiler and cargo package manager via rustup
if [ ! -d ~/.rustup ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

## Software installed via pip/pipx or cargo
pip install pipx

# Pretty and context aware git diffs
cargo install git-delta
