# .bashrc
# Author: Madhu Srinivasan <madhu.srinivasan@outlook.com>
# Source: http://github.com/durdn/cfg/.bashrc

#Global options {{{
export HISTFILESIZE=999999
export HISTSIZE=999999
export HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
shopt -s checkwinsize
shopt -s progcomp
#make sure the history is updated at every command
export PROMPT_COMMAND="history -a; history -n;"

#!! sets vi mode for shell
set -o vi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bashrc ] && ! shopt -oq posix; then
    . /etc/bashrc
fi

#set the terminal type to 256 colors
export TERM=xterm-256color


# }}}
# Tmux startup {{{
#if which tmux 2>&1 >/dev/null; then
    ## if no session is started, start a new session
    #test -z ${TMUX} && tmux

    ## when quitting tmux, try to attach
    #while test -z ${TMUX}; do
        #tmux attach || break
    #done
#fi
# }}}
# Bashmarks from https://github.com/huyng/bashmarks (see copyright there) {{{

# USAGE:
# s bookmarkname - saves the curr dir as bookmarkname
# g bookmarkname - jumps to the that bookmark
# g b[TAB] - tab completion is available
# l - list all bookmarks

# save current directory to bookmarks
touch ~/.sdirs
function s {
  cat ~/.sdirs | grep -v "export DIR_$1=" > ~/.sdirs1
  mv ~/.sdirs1 ~/.sdirs
  echo "export DIR_$1=$PWD" >> ~/.sdirs
}

# jump to bookmark
function g {
  source ~/.sdirs
  cd $(eval $(echo echo $(echo \$DIR_$1)))
}

# list bookmarks with dirnam
function l {
  source ~/.sdirs
  env | grep "^DIR_" | cut -c5- | grep "^.*="
}
# list bookmarks without dirname
function _l {
  source ~/.sdirs
  env | grep "^DIR_" | cut -c5- | grep "^.*=" | cut -f1 -d "="
}

# completion command for g
function _gcomp {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '`_l`' -- $curw))
    return 0
}

# bind completion command for g to _gcomp
complete -F _gcomp g
# }}}
# Fixes hg/mercurial {{{
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# }}}
#Global aliases  {{{

function f {
  find . -type f | grep -v .svn | grep -v .git | grep -i $1
}

function gr {
  find . -type f | grep -v .svn | grep -v .git | xargs grep -i $1 | grep -v Binary
}

# print only column x of output
function col {
  awk -v col=$1 '{print $col}'
}

# skip first x words in line
function skip {
    n=$(($1 + 1))
    cut -d' ' -f$n-
}


function xr {
  case $1 in
  1)
    xrandr -s 1680x1050
    ;;
  2)
    xrandr -s 1440x900
    ;;
  3)
    xrandr -s 1024x768
    ;;
  esac
}


# }}}

# Linux specific config {{{
if [ $(uname) == "Linux" ]; then
  shopt -s autocd
  [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

  # enable color support of ls and also add handy aliases
  if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias ls='ls --color=auto'
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
  fi

  #alias assumed="git ls-files -v | grep ^[a-z] | sed -e 's/^h\ //'"
  alias assumed="git ls-files -v | grep ^h | sed -e 's/^h\ //'"
  # Add an "alert" alias for long running commands.  Use like so: sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

  #apt aliases
  alias apt='sudo apt-get'
  alias cs='sudo apt-cache search'
  alias pacman='sudo pacman'
  alias pac='sudo pacman'

  alias ls='ls --color=auto'
  alias ll='ls -l --color=auto'
  alias la='ls -al --color=auto'
  alias less='less -R'


  if [ -d $HOME/.rbenv ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)";
  fi

  #PATH=$PATH:$HOME/dev/apps/node/bin
fi


# }}}
# OSX specific config {{{
if [ $(uname) == "Darwin" ]; then
  export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/Cellar/python/2.7.3/bin:/usr/local/share/python:$HOME/bin:$PATH
  export MANPATH=/opt/local/share/man:$MANPATH

  #aliases
  alias ls='ls -G'
  alias ll='ls -lG'
  alias la='ls -alG'
  alias less='less -R'
  alias fnd='open -a Finder'
  alias gitx='open -a GitX'
  alias grp='grep -RIi'
  alias assumed="git ls-files -v | grep ^[a-z] | sed -e 's/^h\ //'"

fi

# }}}

# starship {{{
export PATH=~/.starship/bin:$PATH
eval "$(starship init bash)"
# }}}

# # liquid prompt {{{
# source $HOME/.liquidprompt
# #LP_ENABLE_SVN=0
# #LP_ENABLE_FOSSIL=0
# #LP_ENABLE_BZR=0
# #LP_ENABLE_BATT=0
# #LP_ENABLE_LOAD=0
# #LP_ENABLE_PROXY=0
# #LP_USER_ALWAYS=0
# # }}}

### Madhu's Customizations

# OSX specific config {{{
if [ $(uname) == "Darwin" ]; then

    # homebrew init
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # bash completion stuff
    [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
    #homebrew git autocompletions
    if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
        . `brew --prefix`/etc/bash_completion.d/git-completion.bash
    fi
    
    emacs-session(){
        server_name="${1:-noname}"
        emacs_cmd="emacsclient -c -nw -t -s $server_name ."
        eval $emacs_cmd 
    }
    
    kill-emacs-session(){
        server_name="${1:-noname}"
        kill_emacs_cmd="emacsclient -s $server_name -e \"(kill-emacs)\" "
        eval $kill_emacs_cmd 
    }
    
    alias emacs="emacsclient -nw -t"
    alias kill-emacs="emacsclient -e '(kill-emacs)'"
    export ALTERNATE_EDITOR=""
    export EDITOR="emacsclient -nw -t"
    export VISUAL="emacsclient -nw -t"
    export LP_ENABLE_TEMP=0
   
    #emacs
    # alias emacs="emacsclient -nw -t --alternate-editor=\"\" "
    # alias kill-emacs="emacsclient -e '(kill-emacs)'"
    # export EDITOR="emacsclient --alternate-editor=\"\" -t"
    # export VISUAL="emacsclient --alternate-editor=\"\" -t"

    
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

    # rvm setup {{{
    if [ -e $HOME/.rvm/scripts/rvm ]; then
      source $HOME/.rvm/scripts/rvm
      PATH=$PATH:$HOME/.rvm/bin
    fi
    # }}}

    #rustup - basically contents of $HOME/.cargo/env
    export PATH="$HOME/.cargo/bin:$PATH"

    #nodejs and nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    #Lmod setup on osx
    if [ -f /usr/local/opt/lmod/init/profile ]; then
        . /usr/local/opt/lmod/init/profile
    fi
    # module use ~/OSX/modulefiles

    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

    # osx common-lisp-jupyter
    export PATH=$PATH:~/.roswell/bin
    # taken from https://stackoverflow.com/questions/36494336/npm-install-error-unable-to-get-local-issuer-certificate
    function setup-certs() {
        # place to put the combined certs
        local cert_path="$HOME/.certs/all.pem"
        local cert_dir=$(dirname "${cert_path}")
        [[ -d "${cert_dir}" ]] || mkdir -p "${cert_dir}"
        # grab all the certs
        security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > "${cert_path}"
        security find-certificate -a -p /Library/Keychains/System.keychain >> "${cert_path}"
        # configure env vars for commonly used tools
        export GIT_SSL_CAINFO="${cert_path}"
        export AWS_CA_BUNDLE="${cert_path}"
        export NODE_EXTRA_CA_CERTS="${cert_path}"
        # add the certs for npm and yarn
        # and since we have certs, strict-ssl can be true
        npm config set -g cafile "${cert_path}"
        npm config set -g strict-ssl true
        yarn config set cafile "${cert_path}" -g
        yarn config set strict-ssl true -g
        export REQUESTS_CA_BUNDLE="${cert_path}"
    }
    if [ ! -f $HOME/.certs/all.pem ]; then
        setup-certs
    fi
    # configure env vars for commonly used tools
    cert_path="$HOME/.certs/all.pem"
    export GIT_SSL_CAINFO="${cert_path}"
    export AWS_CA_BUNDLE="${cert_path}"
    export NODE_EXTRA_CA_CERTS="${cert_path}"
    export CURL_CA_BUNDLE="${cert_path}"
    
    # Include cursor cli in PATH
    export PATH="$HOME/.local/bin:$PATH"

fi
# }}}

# Linux specific config {{{
if [ $(uname) == "Linux" ]; then

    # Source global definitions
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi

    # Scripts common to all configurations
    umask 002

    # !! IMPORTANT !! this must go *before* the conda init block
    #
    # Do not automatically activate the base environment
    # during shell initialization.
    export CONDA_AUTO_ACTIVATE_BASE=false

    # local bin/
    export PATH="$HOME/.local/bin:$PATH"

    
    if [ "$(lsb_release -sir)" == $'Ubuntu\n24.04' ]
    then
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Detected host Ubuntu 24.04"
        fi

        # MADHU - need to setup Lmod here as well.
	      source /usr/share/lmod/lmod/init/profile
        module use /home/madsrini/Ubuntu-22.04/modulefiles

        # rustup.rs needs this
        export PATH="$HOME/.cargo/bin:$PATH"
        export PATH="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:$PATH"
        # nvm needs this
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('/home/madsrini/Ubuntu-22.04/software/anaconda3/2024.10/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/home/madsrini/Ubuntu-22.04/software/anaconda3/2024.10/etc/profile.d/conda.sh" ]; then
                . "/home/madsrini/Ubuntu-22.04/software/anaconda3/2024.10/etc/profile.d/conda.sh"
            else
                export PATH="/home/madsrini/Ubuntu-22.04/software/anaconda3/2024.10/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<

        # snap bin path needs to be upfront
        export PATH="/snap/bin:$PATH"
	
    elif [ "$(lsb_release -sir)" == $'Ubuntu\n22.04' ]
    then
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Detected host Ubuntu 22.04"
        fi

        # MADHU - need to setup Lmod here as well.
	      source /usr/share/lmod/lmod/init/profile
        module use /home/madsrini/Ubuntu-22.04/modulefiles

        # rustup.rs needs this
        export PATH="$HOME/.cargo/bin:$PATH"
        export PATH="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:$PATH"
        # nvm needs this
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('/home/madsrini/Ubuntu-22.04/software/anaconda3/2023.07/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/home/madsrini/Ubuntu-22.04/software/anaconda3/2023.07/etc/profile.d/conda.sh" ]; then
                . "/home/madsrini/Ubuntu-22.04/software/anaconda3/2023.07/etc/profile.d/conda.sh"
            else
                export PATH="/home/madsrini/Ubuntu-22.04/software/anaconda3/2023.07/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<

        # snap bin path needs to be upfront
	      export PATH="/snap/bin:$PATH"

    elif [[ "$(uname -n)" == *"hpcfund" ]]
    then
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Detected host $(uname -n)"
        fi

        #MADHU - need to setup Lmod here as well.
        module use /home1/madsrini/Ubuntu-22.04/modulefiles

        # rustup.rs needs this
        export PATH="$HOME/.cargo/bin:$PATH"
        export PATH="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:$PATH"
        # nvm needs this
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('/home1/madsrini/Ubuntu-22.04/software/anaconda3/2024.10/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/home1/madsrini/Ubuntu-22.04/software/anaconda3/2024.10/etc/profile.d/conda.sh" ]; then
                . "/home1/madsrini/Ubuntu-22.04/software/anaconda3/2024.10/etc/profile.d/conda.sh"
            else
                export PATH="/home1/madsrini/Ubuntu-22.04/software/anaconda3/2024.10/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<

        # for hpcfund we will use conda because it provides python 3.12
        conda activate base
    else
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Unkown Linux Distribution"
        fi
    fi


    emacs-session(){
        server_name="${1:-noname}"
        emacs_cmd="emacsclient -c -nw -t -s $server_name ."
        eval $emacs_cmd 
    }
    
    kill-emacs-session(){
        server_name="${1:-noname}"
        kill_emacs_cmd="emacsclient -s $server_name -e \"(kill-emacs)\" "
        eval $kill_emacs_cmd 
    }
    
    alias emacs="emacsclient -nw -t"
    alias kill-emacs="emacsclient -e '(kill-emacs)'"
    export ALTERNATE_EDITOR=""
    export EDITOR="emacsclient -nw -t"
    export VISUAL="emacsclient -nw -t"
    export LP_ENABLE_TEMP=0
    
    # Cursor cli definitions
    export PATH="$HOME/.local/bin:$PATH"

    # add special per-host customizations here
    if [ "$(uname -n)" == $'bel-a100' ]; then
        CUDA_HOME="/usr/local/cuda"
        export PATH="$CUDA_HOME/bin":$PATH
        export LIBRARY_PATH="$CUDA_HOME/lib64":$LIBRARY_PATH
        export LD_LIBRARY_PATH="$CUDA_HOME/lib64":$LD_LIBRARY_PATH
        export CMAKE_LIBRARY_PATH="$CUDA_HOME/lib64":$CMAKE_LIBRARY_PATH
        export CMAKE_INCLUDE_PATH="$CUDA_HOME/include":$CMAKE_INCLUDE_PATH
    fi
    
    # add special per-host customizations here
    if [ "$(uname -n)" == $'bel-gfx0' ]; then
        # Linux unlock gnome keyring
        function unlock-keyring ()
        {
            read -rsp "Password: " pass
            export $(echo -n "$pass" | gnome-keyring-daemon --replace --unlock)
            unset pass
        }
        # unlock-keyring
    fi


fi
# }}}
