if [[ $( uname -s ) == "Darwin" ]]; then
  export IS_MAC=1
else
  export IS_MAC=0
fi

source ~/.solarized

if [[ $IS_MAC == 1 ]]; then
  alias ls="ls -G"
else
  alias ls="ls --color=always"
fi
alias postgresup='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias postgresup-public='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log -o "-h 0.0.0.0" start'
alias postgresdown='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias ip-address="ifconfig | grep -Eo 'inet [0-9.]+' | grep -Eo '[0-9.]+' | grep -vF '127.0.0.1' | cat"

export EDITOR=vim
export PATH=${HOME}/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH

if [ -f ${HOME}/.gpg-agent-info ]
then
  source ${HOME}/.gpg-agent-info
elif [ -e ${HOME}/.gnupg/S.gpg-agent.ssh ]
then
  export SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh
else
  eval "$( gpg-agent --daemon )"
fi

if [ -f /usr/local/bin/virtualenvwrapper.sh ]
then
  export VIRTUALENVWRAPPER_PYTHON='/usr/local/bin/python2'
  source /usr/local/bin/virtualenvwrapper.sh
else
  :  # no-op
fi

if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]
then
  source /usr/local/etc/bash_completion.d/git-completion.bash
else
  :  # no-op
fi

if [ -f /usr/local/etc/bash_completion.d/npm ]
then
  source /usr/local/etc/bash_completion.d/npm
else
  :  # no-op
fi

[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PYENV_ROOT="$HOME/.pyenv"
if [ -f $PYENV_ROOT/bin/pyenv ]
then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
else
  :  # no-op
fi

pewtwo_path=$( which pewtwo )
if [ -z ${pewtwo_path} ]
then
  source $(pewtwo shell_config)
else
  :  # no-op
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
