#!/bin/bash
REPO_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Uninstall in case we've run this before
${REPO_ROOT}/uninstall.sh

# Prompt for useful variables
read -p 'What is your name? ' REAL_NAME
read -p 'What is your email address? ' EMAIL_ADDRESS

# Shell colors
echo 'Shell colors'
ln -s ${REPO_ROOT}/solarized ${HOME}/.solarized

# Vim configuration
echo 'Vim configuration'
ln -s ${REPO_ROOT}/vimrc ${HOME}/.vimrc
mkdir -p ${HOME}/.vim/bundle
if [ ! -d ${HOME}/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall

# GPG configuration and keyserver certificate chain
echo 'GPG configuration'
mkdir -p ${HOME}/.gnupg
ln -s ${REPO_ROOT}/gnupg/gpg.conf ${HOME}/.gnupg/gpg.conf
ln -s ${REPO_ROOT}/gnupg/gpg-agent.conf ${HOME}/.gnupg/gpg-agent.conf
ln -s ${REPO_ROOT}/gnupg/sks-keyservers.netCA.pem ${HOME}/.gnupg/sks-keyservers.netCA.pem

# Git configuration
echo 'Git configuration'
REAL_NAME=${REAL_NAME} EMAIL_ADDRESS=${EMAIL_ADDRESS} erb ${REPO_ROOT}/gitconfig.erb > ${HOME}/.gitconfig

# Bash configuration
echo 'Bash configuration'
ln -s ${REPO_ROOT}/bash_profile ${HOME}/.bash_profile

# RVM configuration
echo 'RVM configuration'
ln -s ${REPO_ROOT}/rvmrc ${HOME}/.rvmrc
