if [[ $( uname -s ) == "Darwin" ]]; then
  IS_MAC=1
else
  IS_MAC=0
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

export EDITOR=vim
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

if [ -f ${HOME}/.gpg-agent-info ]
then
  source ${HOME}/.gpg-agent-info
fi
if [ -f /usr/local/bin/virtualenvwrapper.sh ]
then
  source /usr/local/bin/virtualenvwrapper.sh
else
  echo 'TODO: Install virtualenvwrapper'
fi
if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]
then
  source /usr/local/etc/bash_completion.d/git-completion.bash
elif [ -f /etc/bash_completion.d/git-prompt ]
then
  :  # no-op
else
  echo "TODO: Install git"
fi
if [ -f /usr/local/etc/bash_completion.d/npm ]
then
  source /usr/local/etc/bash_completion.d/npm
elif [ -f /etc/bash_completion.d/npm ]
then
  :  # no-op
else
  echo "TODO: Install node/npm"
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
