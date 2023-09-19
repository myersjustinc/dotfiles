#!/bin/bash
# Check for Ruby--needed for Homebrew handling and for template rendering
if [ -z $( which ruby ) ] || [ -z $( which erb ) ]; then
  echo "FATAL: Ruby not installed properly"
  exit 1
fi

# Set useful variables for later
if [[ $( uname -s ) == "Darwin" ]]; then
  IS_MAC=1
  HOMEBREW_PREFIX="$(brew --prefix)"
else
  IS_MAC=0
fi
REPO_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Uninstall in case we've run this before
${REPO_ROOT}/uninstall.sh

# Let the user know we're about to install things
echo 'INSTALLING'

# Prompt for useful variables
REAL_NAME=$1
if [ -z "${REAL_NAME}" ]; then
  read -p ' What is your name? ' REAL_NAME
fi
EMAIL_ADDRESS=$2
if [ -z "${EMAIL_ADDRESS}" ]; then
  read -p ' What is your email address? ' EMAIL_ADDRESS
fi

# Shell colors
echo ' Shell colors'
ln -s ${REPO_ROOT}/solarized ${HOME}/.solarized

# Vim configuration
echo ' Vim configuration'
ln -s ${REPO_ROOT}/vimrc ${HOME}/.vimrc
mkdir -p ${HOME}/.vim/bundle
if [ ! -d ${HOME}/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall

# GPG configuration and keyserver certificate chain
echo ' GPG configuration'
mkdir -p ${HOME}/.gnupg
erb ${REPO_ROOT}/gnupg/gpg.conf.erb > ${HOME}/.gnupg/gpg.conf
IS_MAC=${IS_MAC} HOMEBREW_PREFIX=${HOMEBREW_PREFIX} erb ${REPO_ROOT}/gnupg/gpg-agent.conf.erb > ${HOME}/.gnupg/gpg-agent.conf
ln -s ${REPO_ROOT}/gnupg/sks-keyservers.netCA.pem ${HOME}/.gnupg/sks-keyservers.netCA.pem

# Git configuration
echo ' Git configuration'
REAL_NAME=${REAL_NAME} EMAIL_ADDRESS=${EMAIL_ADDRESS} erb ${REPO_ROOT}/gitconfig.erb > ${HOME}/.gitconfig

# IRB configuration
echo ' IRB configuration'
ln -s ${REPO_ROOT}/irbrc ${HOME}/.irbrc

# Bash configuration
echo ' Bash configuration'
ln -s ${REPO_ROOT}/bash_profile ${HOME}/.bash_profile
ln -s ${REPO_ROOT}/bashrc ${HOME}/.bashrc

# RVM configuration
echo ' RVM configuration'
ln -s ${REPO_ROOT}/rvmrc ${HOME}/.rvmrc
