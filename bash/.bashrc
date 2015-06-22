# .bashrc
# If non-interactive (x2go session start/resume, scp, etc.), PS1 is not set and therefore the statement below exits.
[ -z "$PS1" ] && return

#########################
# Source global definitions
#########################
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Remember, each simulator brings its own gcc, however, use of 'Environment Modules' (via tools/oss) will make it a no problem.

# QT Designer is a nice GUI for quickly generating GUI that could be copy/pasted
# to power point slides. It can also be used to generate C or TCL/TK source code
# to produce the designed GUI. It needs gcc which conflicts with xilinx settings.
# The following variable (qt_designer), when set to "yes", makes qt working, but
# xilinx tools will not be on the path, i.e. can't be used. If it's set to "no",
# qt can't be used, but xilinx tools can be.
qt_designer=no

    # Open source tools (Cloud/grid, Jedit, git, svn, meld, tig, etc.)
    alias source_oss='source /tools/oss/latest.env_var.sh'

    # Code Review tools (Prefer Atlassian tools:  Crucible (Code Review), well integrated with JIRA (issue mgmt) and FishEye (repo mgmt))
    alias source_codereview='source /tools/smartbear/peerreview/latest.env_var.sh'

# gtkterm - Hyperterminal equivalent for linux
alias sourcetools='source_oss;source_codereview'

host=`hostname -s`

if [ `echo $host | grep "odikmen-" | wc -l` == 1 ]; then
    echo "Appears we are on a this user's client, $host, so setting up 'Environment Modules' package to be able to load/unload FPGA dev tools on demand"
    sourcetools;
elif [ `echo $host | grep "\-linux" | wc -l` == 1 ]; then
    echo "Appears we are not on this user's client, $host, so skipping the set up of 'Environment Modules' package"
fi


#########################
# Aliases
#########################
alias d='ls -lA --color'    # TODO: I did not need to specify --color in ubuntu 10.04 (until Dec 12, 2012). After transitioned to FC17 on Dec 12, I lost colors and I had to add '--color' to get colorful ls output. However, what is the real solution? Is PS1 at fault? If so, why was it working with ubuntu?  Does /etc/bash or some profile in FC17 mess things up?
alias ll='ls -l --color'    # TODO: I did not need to specify --color in ubuntu 10.04 (until Dec 12, 2012). After transitioned to FC17 on Dec 12, I lost colors and I had to add '--color' to get colorful ls output. However, what is the real solution? Is PS1 at fault? If so, why was it working with ubuntu?  Does /etc/bash or some profile in FC17 mess things up?
# Force the confirmation when deleting/overwriting files
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# -R option makes 'less' interpret colors correctly similar to what 'more' does by default, however, searching for text becomes not possible.
# -S has to do with line wrapping
# -X prevents less from remembering the content of the screen prior to running it.
# With the LESS env var, 'man' also works like less does.
#alias less='less -R -S'
export LESS="-X -R -S"

# htop does not like any TERM but xterm. Ex: If xterm=screen, htop does not work properly.
alias htop='TERM=xterm htop'

# -c: Show full command line (all the args that were passed when the process got started)
# -M: Display memory size in human readable way
alias top='top -M -c'

# Grid engine - process status
alias qstat='qstat -u "*"'

# Display tree style process map, i.e. parent-child relations are displayed graphically
alias pstree='pstree -Gpl'

# Display start time of the specified PID: psst $PID
alias psst='ps ho lstart'

# Make grep highlight the matches in its output
alias grep="grep --color"

# Print dot files (a), full path on every line (f), use colors for dirs (C), turn on ANSI line graphics hack when printing the indentation lines (A)
alias tree="tree -afCA"

alias history='history 50'

# PDF editor
alias pdfe='master-pdf-editor'

# Ignore all the untrusted user and Gtk related problems
alias thgnull='thg 2>/dev/null'

# Graphical disk usage tool (alternative to du)
alias gdu='baobab 2>/dev/null'

# License Status
lic_server='lab-66034'
alias lic_aldec='lmutil lmstat -a -c 27009@$lic_server'
alias lic_altera='lmutil lmstat -a -c 1802@$lic_server'

# ssh machines
alias sshdik='ssh odikmen-64008'
alias sshbw='ssh pinnacle-lab-ch-02'    # The rack-mount PC containing the Bittware board for experimentation
alias sshlic='ssh $lic_server'          # License Server

myCd() {
    cd `pwd | sed -e "s/$1/$2/"`
}
alias chd=myCd

# Try to preserve current path after ssh'ing to the new machine
mySsh() {
    local nwd
    test -z "$2" && nwd=`pwd | sed -e 's/home-local/home/' | sed -e 's/\/net\/nfs\/atlantic//'` || nwd=$2
    /usr/bin/ssh -X -t $1 "cd $nwd; /bin/bash"
}
alias ssh=mySsh

umask 0022

# My files in $HOME/bin are better than those introduced by /tools/oss/latest.env_var.sh :)
PATH=$HOME/bin:$PATH

# Clean up duplicates from PATH
export PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++')

export EDITOR=vim

#export PS1='[\[\e[1;31m\]\u\[\e[1;30m\]@\[\e[1;34m\]\h \W\[\e[1;30m\]\$\[\e[0m\]] '

##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlenS characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlenS=20
##################################################
bash_prompt_command() {
    # How many characters of the $PWD should be kept
    local pwdmaxlenS=25     # at the prompt
    local pwdmaxlenT=85     # on the title bar

    # prompt, i.e. Status line
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlenS=$(( ( pwdmaxlenS < ${#dir} ) ? ${#dir} : pwdmaxlenS ))
    NEW_PWDS=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWDS} - pwdmaxlenS ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWDS=${NEW_PWDS:$pwdoffset:$pwdmaxlenS}
        NEW_PWDS=${trunc_symbol}/${NEW_PWDS#*/}
    fi

    # Title bar
    pwdmaxlenT=$(( ( pwdmaxlenT < ${#dir} ) ? ${#dir} : pwdmaxlenT ))
    NEW_PWDT=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWDT} - pwdmaxlenT ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWDT=${NEW_PWDT:$pwdoffset:$pwdmaxlenT}
        NEW_PWDT=${trunc_symbol}/${NEW_PWDT#*/}
    fi

    # Truncate HOSTNAME
    if [[ $HOSTNAME =~ fpga-[0-9][0-9]- ]]; then
        myhostnum=`hostname -s | /bin/sed -e 's/\(.*\)-linux.*/\1/'`
    elif [[ $HOSTNAME =~ fpga ]]; then
        myhostnum=`hostname -s | /bin/sed -e 's/fpga-\(.*\)-\(.\)-linux.*/\1/'`
        myhostlet=`hostname -s | /bin/sed -e 's/fpga-\(.*\)-\(.\)-linux.*/\2/'`
    else
        myhostnum=`hostname -s | /bin/sed -e 's/\(.*\)-linux.*/\1/'`
        myhostlet=""
    fi
    export myhostnum
    export myhostlet

    #echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${NEW_PWDS/#$HOME/~}\007"

    # This will keep $LOCALBRANCHGIT and $REMOTEBRANCHGIT updated with the root path of the current git working copy
    # Add a git-friendly prompt
    local LOCALBRANCHHG=`hg branch 2> /dev/null`
    local REMOTEBRANCHHG=""
    local LOCALBRANCHGIT=`git branch --no-color 2> /dev/null | /bin/sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    local REMOTEBRANCHGIT=`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null | /bin/sed -e 's/^origin\(.*\)/origin\1/'`

    if `cd $PWD && [ -d .hg ] || hg identify >> /dev/null 2>&1`; then
        VIEWROOT=$PWD
        VIEWBASE=$VIEWROOT
        VIEWNAME="$LOCALBRANCHHG <=> $REMOTEBRANCHHG"
    elif `cd $PWD && [ -d .git ] || git rev-parse --git-dir >> /dev/null 2>&1`; then
        VIEWROOT=`echo ${PWD} | /bin/sed -e "s/\(.*$LOCALBRANCHGIT\).*/\1/"`
        VIEWBASE=$VIEWROOT
        VIEWNAME="$LOCALBRANCHGIT <=> $REMOTEBRANCHGIT"
    else
        VIEWROOT=$PWD
        VIEWBASE=""
        VIEWNAME=""
    fi
    export VIEWBASE
    export VIEWNAME

    case $TERM in
     xterm*|rxvt*|screen*)
         printf "\033]0;%-80s %50s\007" "$USER@${myhostnum}${myhostlet}:${NEW_PWDT}" "<${VIEWNAME}>"
          ;;
     *)
         printf ""
          ;;
    esac
}

bash_prompt() {
    #case $TERM in
    # xterm*|rxvt*|screen*)
    #     local TITLEBAR='\[\033]0;\u@\h:${NEW_PWDL}  <${VIEWNAME}>\007\]'
    #      ;;
    # *)
    #     local TITLEBAR=""
    #      ;;
    #esac
    local NONE="\[\033[0m\]"    # unsets color to term's fg color

    # regular colors
    local K="\[\033[0;30m\]"    # black
    local R="\[\033[0;31m\]"    # red
    local G="\[\033[0;32m\]"    # green
    local Y="\[\033[0;33m\]"    # yellow
    local B="\[\033[0;34m\]"    # blue
    local M="\[\033[0;35m\]"    # magenta
    local C="\[\033[0;36m\]"    # cyan
    local W="\[\033[0;37m\]"    # white

    # non-emphasized (non-bolded) colors
    local EMk="\[\033[0;30m\]"
    local EMr="\[\033[0;31m\]"
    local EMg="\[\033[0;32m\]"
    local EMy="\[\033[0;33m\]"
    local EMb="\[\033[0;34m\]"
    local EMm="\[\033[0;35m\]"
    local EMc="\[\033[0;36m\]"
    local EMw="\[\033[0;37m\]"

    # emphasized (bolded) colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
    local EMG="\[\033[1;32m\]"
    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
    local EMM="\[\033[1;35m\]"
    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"

    # background colors
    local BGK="\[\033[40m\]"
    local BGR="\[\033[41m\]"
    local BGG="\[\033[42m\]"
    local BGY="\[\033[43m\]"
    local BGB="\[\033[44m\]"
    local BGM="\[\033[45m\]"
    local BGC="\[\033[46m\]"
    local BGW="\[\033[47m\]"

    local UC=$EMM                 # user's color
    [ $UID -eq "0" ] && UC=$EMR   # root's color

    # HISTTIMEFORMAT (history uses it) provides when the command execution started. The time on the prompt provides when it ended ==> Effectively, all commands are executed as if 'time ' is always used.
    #PS1="[${UC}\u${EMK}@${EMB}\h \${NEW_PWDS}${K}\${NONE}]$ "
    PS1="${EMC}[${UC}\u${EMK}@${EMB}${myhostnum}${EMC}${myhostlet} ${EMB}\${NEW_PWDS}${EMC}]${K}${NONE} ${EMy}(\D{%F %T})${K}${NONE}\\$ "
    # without colors: PS1="[\u@\h \${NEW_PWDS}]\\$ "
    # extra backslash in front of \$ to make bash colorize the prompt
}

PROMPT_COMMAND=bash_prompt_command
bash_prompt_command
bash_prompt
unset bash_prompt

#--------------------------------------------------------------------------------
# This is required to change screen's socket directory from /tmp
export SCREENDIR=$HOME/.screen/$HOSTNAME
mkdir -p $SCREENDIR
chmod 700 $SCREENDIR

#--------------------------------------------------------------------------------
# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#--------------------------------------------------------------------------------
# Command line HISTORY
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth
# ignore certain commands
HISTIGNORE=fortune:exit:clear:pwd:ls
# Timestamp the command execution start time
export HISTTIMEFORMAT="%Y%m%d %H:%M:%S "
# append to the history file, don't overwrite it
shopt -s histappend
export HISTSIZE=1000000
export HISTFILESIZE=1000000000

#--------------------------------------------------------------------------------
# Echo an easy to copy line for setting the current display (mainly for updating existing screens)
mkdir -p ~/.curDisplay
alias sourcecurdisplay='source ~/.curDisplay/${HOSTNAME}'
alias updatecurdisplay='echo "export DISPLAY=$DISPLAY" > ~/.curDisplay/${HOSTNAME}'

fromssh=`echo $DISPLAY | grep localhost`
echo "DEBUG: fromssh   =$fromssh"
echo "DEBUG: SSH_CLIENT=$SSH_CLIENT"
echo "DEBUG: SSH_TTY   =$SSH_TTY"
echo "DEBUG: TERM      =$TERM"
#if [ "$fromssh" != "" ]; then
#sourcecurdisplay
if [ -n "$SSH_CLIENT" ] && [ -n "$SSH_TTY" ]; then
    echo "ssh term: export DISPLAY=$DISPLAY"
elif [ "$TERM" == "screen" ]; then
    sourcecurdisplay
    echo "screen term: export DISPLAY=$DISPLAY"
else
    echo "export DISPLAY=$DISPLAY" > ~/.curDisplay/${HOSTNAME}
    echo "NX term: export DISPLAY=$DISPLAY"
fi
#if [ $TERM != "screen" ]; then
#    echo "export DISPLAY=$DISPLAY" > ~/.curDisplay/${HOSTNAME}
#    echo "export DISPLAY=$DISPLAY"
#else
#    source ~/.curDisplay/${HOSTNAME}
#    echo "export DISPLAY=$DISPLAY"
#fi

#--------------------------------------------------------------------------------
# Bash cd history
source $HOME/bin/acd_func.sh

# Following command makes sure that xterm reads its parameters from .Xresources at its launch time.
# If .Xresources is modified, following commands needs to be re-run and then xterm needs to be re-started before the changes to take affect.
xrdb $HOME/.Xresources
