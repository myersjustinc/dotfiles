source ~/.solarized

alias ls="ls -G"
alias postgresup='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias postgresdown='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

export EDITOR=vim
export PATH=/usr/local/bin:$PATH

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
else
  echo "TODO: Install Homebrew's git"
fi
if [ -f /usr/local/etc/bash_completion.d/npm ]
then
  source /usr/local/etc/bash_completion.d/npm
else
  echo "TODO: Install Homebrew's node/npm"
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
