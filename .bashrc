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
    
    
    #emacs
    alias emacs="emacsclient -nw -t --alternate-editor=\"\" "

    alias kill-emacs="emacsclient -e '(kill-emacs)'"
    export EDITOR="emacsclient --alternate-editor=\"\" -t"
    export VISUAL="emacsclient --alternate-editor=\"\" -t"

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
    }
    setup-certs

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

    umask 002

    # Options for KVL CentOS7 Systems
    if [ "$(lsb_release -sir)" == "CentOS 7.6.1810" ]
    then
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Detected $(lsb_release -sir)"
        fi
        # setup Lmod
        source /usr/share/lmod/lmod/init/profile


        module use /home/srinivm/CentOS7/modulefiles
        module load emacs/24.5
        #system scripts
        export PATH="/scheduler/ibex/scripts/bin:$PATH"
        #rustup
        export PATH="$HOME/.cargo/bin:$PATH"
        module use /var/remote/projects/software/modules/sets
        # nvm needs this
        export NVM_DIR="/home/srinivm/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('/home/srinivm/CentOS7/software/anaconda/python3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/home/srinivm/CentOS7/software/anaconda/python3/etc/profile.d/conda.sh" ]; then
                . "/home/srinivm/CentOS7/software/anaconda/python3/etc/profile.d/conda.sh"
            else
                export PATH="/home/srinivm/CentOS7/software/anaconda/python3/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<

    # Options for IBEX Cluster
    elif [ "$(lsb_release -sir)" == "CentOS 7.5.1804" ]
    then
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Detected $(lsb_release -sir)"
        fi
        # setup Lmod
        #source /usr/share/lmod/lmod/init/profile

        module use /home/srinivm/IBEX/modulefiles
        #module load emacs/24.5

        #system scripts
        export PATH="/scheduler/ibex/scripts/bin:$PATH"

        #rustup
        export PATH="$HOME/.cargo/bin:$PATH"
        # module use /var/remote/projects/software/modules/sets
        # nvm needs this
        export NVM_DIR="/home/srinivm/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    elif [ "$(lsb_release -sir)" == "Scientific 6.9" ]
    then
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Detected $(lsb_release -sir)"
        fi
        source /usr/share/Modules/init/bash
        module use /home/srinivm/SL6/modulefiles
        module load emacs/24.5

        #system scripts
        export PATH="/scheduler/ibex/scripts/bin:$PATH"

        # nvm needs this
        export NVM_DIR="/home/srinivm/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
    elif [ "$(lsb_release -sir)" == "SUSE 12.3" ]
    then
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Detected $(lsb_release -sir)"
        fi
        module use /home/srinivm/SUSE/modulefiles
        module use /project/k1033/modulefiles
        module use /lustre/project/k1033/madhu/modulefiles
        module load emacs/24.5
        module load git
        # rustup.rs needs this
        export CARGO_HOME=/lustre/project/k1033/software/rust/.cargo
        export PATH=$CARGO_HOME/bin:$PATH
        export RUSTUP_HOME=/lustre/project/k1033/software/rust/.rustup
    elif [ "$(lsb_release -sir)" == $'Ubuntu\n14.04' ]
    then
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Detected host Ubuntu 14.04"
        fi
        #MADHU - need to setup Lmod here as well.

        #module use /home/srinivm/Ubuntu-14.04/modulefiles
        # rustup.rs needs this
        export PATH="$HOME/.cargo/bin:$PATH"
        # nvm needs this
        export NVM_DIR="/home/srinivm/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
  elif [ "$(lsb_release -sir)" == $'Ubuntu\n22.04' ]
    then
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Detected host Ubuntu 22.04"
        fi

        #MADHU - need to setup Lmod here as well.
	      source /usr/share/lmod/lmod/init/profile
        module use /home/madsrini/Ubuntu-22.04/modulefiles

        # rocm paths - MADHU: This should really be a module
        # export ROCM_PATH=/opt/rocm-5.4.3
        # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/rocm-5.4.3/lib:/opt/rocm-5.4.3/lib64
        # export PATH=$PATH:/opt/rocm-5.4.3/bin:/opt/rocm-5.4.3/opencl/bin

        #rpr dev stuff - MADHU: This should really be a module
        # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/develop/gfx/FireRender/dist/release/bin/x86_64/
        # export PATH=$PATH:~/develop/gfx/FireRender/dist/release/bin/x86_64/

        # rtb paths - MADHU: This should really be a module
        # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/madsrini/develop/gfx/Rtb/dist/bin/release
        # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/madsrini/develop/gfx/Rtb/dist/bin/Release
        # export PATH=$PATH:/home/madsrini/develop/gfx/Rtb/dist/bin/Release

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
  elif [ "$(uname -n)" == $'login1.hpcfund' ]
    then
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Detected host login1.hpcfund"
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
        __conda_setup="$('/home1/madsrini/Ubuntu-22.04/software/anaconda3/2023.07/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "/home1/madsrini/Ubuntu-22.04/software/anaconda3/2023.07/etc/profile.d/conda.sh" ]; then
                . "/home1/madsrini/Ubuntu-22.04/software/anaconda3/2023.07/etc/profile.d/conda.sh"
            else
                export PATH="/home1/madsrini/Ubuntu-22.04/software/anaconda3/2023.07/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<
    else
        if [[ $- =~ "i" ]]; then #print message only if interactive shell
            echo "Unkown Linux Distribution"
        fi
    fi

    alias emacs="emacsclient -nw -t"
    alias kill-emacs="emacsclient -e '(kill-emacs)'"
    export ALTERNATE_EDITOR=""
    export EDITOR="emacsclient -nw -t"
    export VISUAL="emacsclient -nw -t"
    export LP_ENABLE_TEMP=0


fi
# }}}
