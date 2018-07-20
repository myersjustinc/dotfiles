# Prepare to handle Mac-specific config differences if we're on such a machine.
if [[ $( uname -s ) == "Darwin" ]]; then
  export IS_MAC=1
else
  export IS_MAC=0
fi

# Source my customized (Solarized-based) prompt.
source ~/.solarized

# Use color in `ls` output.
if [[ $IS_MAC == 1 ]]; then
  alias ls="ls -G"
  export LSCOLORS='Exfxcxdxbxegedabagacad'
else
  alias ls="ls --color=always"
  export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
fi

# Add handy Postgres aliases for local development.
pg_ctl_path=$( which pg_ctl )
if [ ! -z ${pg_ctl_path} ]
then
  alias postgresup='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
  alias postgresup-public='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log -o "-h 0.0.0.0" start'
  alias postgresdown='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
else
  :  # no-op
fi

# Make it easier to determine this machine's IP address.
alias ip-address="/sbin/ifconfig | grep -Eo 'inet (addr:)?[0-9.]+' | grep -Eo '[0-9.]+' | grep -vF '127.0.0.1' | cat"

# Use Vim by default. This likely is the default anyway, but might as well be
# explicit.
export EDITOR=vim

# Set the $PATH to include things from pipsi and Homebrew.
export PATH=${HOME}/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH

# Configure GPG and SSH.
if [ -f ${HOME}/.gpg-agent-info ]
then
  source ${HOME}/.gpg-agent-info
elif [ -e ${HOME}/.gnupg/S.gpg-agent.ssh ]
then
  export SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh
else
  eval "$( gpg-agent --daemon )"
fi

# Handle legacy virtualenvwrapper setup for machines where I'm still using it.
if [ -f /usr/local/bin/virtualenvwrapper.sh ]
then
  export VIRTUALENVWRAPPER_PYTHON='/usr/local/bin/python2'
  source /usr/local/bin/virtualenvwrapper.sh
else
  :  # no-op
fi

# Load Homebrew's tab-completion files for Git, if applicable.
if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]
then
  source /usr/local/etc/bash_completion.d/git-completion.bash
else
  :  # no-op
fi

# Load Homebrew's tab-completion files for npm, if applicable.
if [ -f /usr/local/etc/bash_completion.d/npm ]
then
  source /usr/local/etc/bash_completion.d/npm
else
  :  # no-op
fi

# Load version managers for Ruby (rvm), Python (pyenv) and Node.js (nvm,
# later), depending on which ones are installed.
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export PYENV_ROOT="$HOME/.pyenv"
if [ -f $PYENV_ROOT/bin/pyenv ]
then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
else
  :  # no-op
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
