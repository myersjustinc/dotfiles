#!/bin/bash
echo 'UNINSTALLING'

echo ' Shell colors'
rm ${HOME}/.solarized

echo ' Vim configuration'
rm ${HOME}/.vimrc

echo ' GPG configuration'
rm ${HOME}/.gnupg/gpg.conf
rm ${HOME}/.gnupg/gpg-agent.conf
rm ${HOME}/.gnupg/sks-keyservers.netCA.pem

echo ' Git configuration'
rm ${HOME}/.gitconfig

echo ' IRB configuration'
rm ${HOME}/.irbrc

echo ' Bash configuration'
rm ${HOME}/.bash_profile

echo ' RVM configuration'
rm ${HOME}/.rvmrc
