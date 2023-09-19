# Prepare to handle Mac-specific or Windows-specific config differences if
# we're on such a machine.
if [[ $( uname -s ) == "Darwin" ]]; then
  export IS_MAC=1
  export IS_WIN=0
else
  export IS_MAC=0
  wsl_test="$(uname -r | grep -Foi -- 'WSL')"
  if [[ $? -eq 0 ]]; then
    export IS_WIN=1
  else
    export IS_WIN=0
  fi
fi

# Source my customized (Solarized-based) prompt.
source ~/.solarized

# Adjust how bash command history is recorded
export HISTCONTROL='ignorespace'

# Use color in `ls` output.
if [[ $IS_MAC == 1 ]]; then
  alias ls="ls -G"
  export LSCOLORS='Exfxcxdxbxegedabagacad'
else
  alias ls="ls --color=always"
  export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
fi

# Avoid clearing the screen upon exiting `less`.
alias less="less -X"

# Add handy Postgres aliases for local development.
export PG_CTL_PATH=$( which pg_ctl )
if [ ! -z ${PG_CTL_PATH} ]
then
  export PG_DB_DIR='/usr/local/var/postgres'
  postgresup() {
    "${PG_CTL_PATH}" \
      -D "${PG_DB_DIR}" \
      -l "${PG_DB_DIR}/server.log" \
      start
  }
  postgresup-public() {
    "${PG_CTL_PATH}" \
      -D "${PG_DB_DIR}" \
      -l "${PG_DB_DIR}/server.log" \
      -o '-h 0.0.0.0' \
      start
  }
  postgresdown() {
    "${PG_CTL_PATH}" \
      -D "${PG_DB_DIR}" \
      stop \
      -s \
      -m fast
  }
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
if [[ $IS_WIN == 1 ]]; then
  # $ powershell.exe '$env:UserName'
  # justi
  # $ powershell.exe '$env:HomePath'
  # \Users\justi
  # $ powershell.exe '$env:HomeDrive'
  # C:
  wsl2_ssh_pageant_path="${HOME}/.ssh/wsl2-ssh-pageant.exe"
  win_home_drive="$(powershell.exe '$env:HomeDrive')"
  win_home_path="$(powershell.exe '$env:HomePath' | sed 's=\\=/=g')"
  gpg_config_path="${win_home_drive}${win_home_path}/AppData/Local/gnupg"
  export SSH_AUTH_SOCK="${HOME}/.ssh/agent.sock"
  export GPG_AGENT_SOCK="${HOME}/.gnupg/S.gpg-agent"
  ss -a | grep -q "${SSH_AUTH_SOCK}"
  if [ $? -ne 0 ]; then
    rm -f "${SSH_AUTH_SOCK}"
    setsid nohup socat \
      "UNIX-LISTEN:${SSH_AUTH_SOCK},fork" \
      "EXEC:${wsl2_ssh_pageant_path}" \
      &>/dev/null &
  fi
  ss -a | grep -q "${GPG_AGENT_SOCK}"
  if [ $? -ne 0 ]; then
    rm -rf "${GPG_AGENT_SOCK}"
    setsid nohup socat \
      "UNIX-LISTEN:${GPG_AGENT_SOCK},fork" \
      "EXEC:'${wsl2_ssh_pageant_path} --gpgConfigBasepath "${gpg_config_path}" --gpg S.gpg-agent'" \
      &>/dev/null &
  fi
else
  if [ -f ${HOME}/.gpg-agent-info ]
  then
    source ${HOME}/.gpg-agent-info
  else
    export SSH_AUTH_SOCK="$( gpgconf --list-dirs agent-ssh-socket )"
    if [ ! -S ${SSH_AUTH_SOCK} ]; then
      eval "$( gpg-agent --daemon )"
    fi
  fi
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

# Load Ubuntu bash-completion if available.
if [ -f /usr/share/bash-completion/bash_completion ]
then
  source /usr/share/bash-completion/bash_completion
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
  export PIPX_BIN_DIR="${HOME}/.local/bin"
  export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PIPX_BIN_DIR:$PATH"
  eval "$(pyenv init --path)"
else
  :  # no-op
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if [[ $IS_WIN == 1 ]]; then
  host_ip="$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')"
  export DISPLAY="${host_ip}:0"
fi

alias random-digits="\
  python -c 'if True:\
    from random import randint; \
    import sys; \
    digits = int(sys.argv[1] if (len(sys.argv) > 1) else 6); \
    print(\"\".join(str(randint(0, 9)) for n in range(digits)))'"

if [ -f "${HOME}/.cargo/env" ]
then
  source "${HOME}/.cargo/env"
fi

# Load machine-specific settings, if applicable.
if [ -f "$HOME/.bashrc_local" ]
then
  source "$HOME/.bashrc_local"
else
  :  # no-op
fi
