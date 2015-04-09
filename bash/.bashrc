# .bashrc
# If non-interactive (x2go session start/resume, scp, etc.), PS1 is not set and therefore the statement below exits.
[ -z "$PS1" ] && return

#########################
# Source global definitions
#########################
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Choose which simulator to use
# Each simulator brings its own gcc, i.e. sets the path up to use their own gcc,
# which creates problems when compiling C files using standard gcc.
#sim=modelsim
#sim=riviera
sim=none

# QT Designer is a nice GUI for quickly generating GUI that could be copy/pasted
# to power point slides. It can also be used to generate C or TCL/TK source code
# to produce the designed GUI. It needs gcc which conflicts with xilinx settings.
# The following variable (qt_designer), when set to "yes", makes qt working, but
# xilinx tools will not be on the path, i.e. can't be used. If it's set to "no",
# qt can't be used, but xilinx tools can be.
qt_designer=no

    # Clearcase
    alias source_clearcase='source /tools/rational/clearcase/latest.env_var.sh'

    # Open source tools (Cloud/grid, Jedit, git, svn, meld, tig, etc.)
    alias source_oss='source /tools/oss/latest.env_var.sh'

    # Code Review tools
    alias source_codereview='source /tools/smartbear/peerreview/latest.env_var.sh'

    # Modelsim (Due to name mismatch (vsim), use either aldec or mentor at a time)
    alias source_modelsim='if [ "$sim" == "modelsim" ]; then source /tools/mentor/modelsim/SE/latest.env_var.sh ; fi'

    # Aldec Riviera (Due to name mismatch (vsim), use either aldec or mentor at a time)
    alias source_riviera='if [ "$sim" == "riviera" ]; then source /tools/aldec/riviera/latest.env_var.sh ; fi'

    # Visual Elite (now Mentor)
    #alias source_visualelite='source /tools/summit/visual_elite/latest.env_var.sh'

    # Synplify
    alias source_synplify='source /tools/synplicity/synplify/latest.env_var.sh'

    # Quartus
    alias source_quartus='source /tools/altera/quartus/latest.env_var.sh'

    # ISE (foundation)
    #alias source_ise='if [ "$sim" != "riviera" -a $qt_designer == "no" ]; then source /tools/xilinx/ISE/foundation/latest.env_var.sh ; fi'

# gtkterm - Hyperterminal equivalent for linux
alias sourcetools='source_clearcase;source_codereview;source_synplify;source_quartus;source_oss'

host=`hostname -s`

if [ `echo $host | grep "dikmeno-linux" | wc -l` == 1 ]; then
    echo "Appears we are on a SW client, $host, so setting up env for SW dev (git, etc.)"
    export KS_DISCIPLINE=sw
    sourcetools;
elif [ `echo $host | grep "\-linux" | wc -l` == 1 ]; then
    echo "Appears we are on an FPGA client, $host, so setting up env for FPGA dev (git, EDA tools, etc.)"
    sourcetools;
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

# Make grep highlight the matches in its output
alias grep="grep --color"

# Print dot files (a), full path on every line (f), use colors for dirs (C), turn on ANSI line graphics hack when printing the indentation lines (A)
alias tree="tree -afCA"

alias history='history 50'

# License Status
alias lic_summit='lmutil lmstat -a -c 26318@rubicon'
alias lic_lattice='lmutil lmstat -a -c 1701@rubicon'
alias lic_orcad='lmutil lmstat -a -c 1700@10.10.53.36'
alias lic_mcad='lmutil lmstat -a -c 27000@10.10.53.36'
alias lic_aldec='lmutil lmstat -a -c 28000@rubicon'
#alias lic_aldec2='lmutil lmstat -a -c 27000@10.1.208.11'
alias lic_cdn1='lmutil lmstat -a -c 5280@lewis'
alias lic_cdn2='lmutil lmstat -a -c 5280@bradbury'
alias lic_synp1='lmutil lmstat -a -c 1709@lewis'
alias lic_synp2='lmutil lmstat -a -c 1709@rubicon'
alias lic_altr='lmutil lmstat -a -c 1800@rubicon'
alias lic_xlnx='lmutil lmstat -a -c 2100@rubicon'
alias lic_model1='lmutil lmstat -a -c 1650@rubicon'
alias lic_model2='lmutil lmstat -a -c 1650@lewis'
alias lic_synop='lmutil lmstat -a -c 2589@rubicon'
alias lic_ease='lmutil lmstat -a -c 1711@rubicon'

# ssh machines
#alias ssh1500a='ssh fpga-1500-a-linux'
#alias ssh2200a='ssh fpga-2200-a-linux'
#alias ssh2800c='ssh fpga-2800-c-linux'
#alias ssh2800d='ssh fpga-2800-d-linux'
#alias ssh2800e='ssh fpga-2800-e-linux'
alias ssh3000a='ssh fpga-3000-a-linux'
#alias ssh3000b='ssh fpga-3000-b-linux' # used as montana-linux / idte since about 2011.

alias ssh06a='ssh fpga-2006-a-linux'    #ssh3000c='ssh fpga-3000-c-linux'
alias ssh07a='ssh fpga-2007-a-linux'    #ssh3000d='ssh fpga-3000-d-linux'
alias ssh08a='ssh fpga-2008-a-linux'    #ssh3160a='ssh fpga-3160-a-linux'
alias ssh10a='ssh fpga-2010-a-linux'    #ssh3330a='ssh fpga-3330-a-linux'
alias ssh11a='ssh fpga-2011-a-linux'    #ssh3460a='ssh fpga-3460-a-linux'
alias ssh12a='ssh fpga-2012-a-linux'
alias ssh13a='ssh fpga-2013-a-linux'
alias ssh13b='ssh fpga-2013-b-linux'
alias ssh13c='ssh fpga-2013-c-linux'

alias ssh50='ssh fpga-50-redhat7-3-linux'
alias ssh51='ssh fpga-51-redhat3-linux'
alias ssh52='ssh fpga-52-redhat4-linux'

alias sshdik='ssh ger-dikmeno-linux-1'

alias gitg='ssh ger-toolmgr-linux-1 gitg'

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
export PATH=$HOME/bin:$PATH

#export PATH="/home/dikmeno/ActiveState/Komodo-IDE-7/bin:$PATH"
export PATH="/home/dikmeno/ActiveState/Komodo-Edit-7/bin:$PATH"
export PATH="/home/dikmeno/bin/eclipse:$PATH"                   # Feb 8, 2013: Until I test out eclim with eclipse (4.2), I need to use my own copy. Let Kavi know if we'd want eclim be part of the master eclipse installer (/opt/eclipse). Also, Veditor is another eclipse plugin, for verilog.
#export PATH="/home-local/dikmeno/ActiveTcl-8.5/bin:$PATH"
#export PATH="/home-local/dikmeno/TclDevKit-5.3/bin:$PATH"
#export PATH="/home-local/dikmeno/SlickEdit/bin:$PATH"
#export PATH="/home-local/dikmeno/git/bin:$PATH"

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

    # This will keep $LOCALBRANCH and $REMOTEBRANCH updated with the root path of the current git working copy
    # Add a git-friendly prompt
    local LOCALBRANCH=`git branch --no-color 2> /dev/null | /bin/sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    local REMOTEBRANCH=`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null | /bin/sed -e 's/^origin\(.*\)/origin\1/'`

    if `cd $PWD && [ -d .git ] || git rev-parse --git-dir >> /dev/null 2>&1`; then
        VIEWROOT=`echo ${PWD} | /bin/sed -e "s/\(.*$LOCALBRANCH\).*/\1/"`
        VIEWBASE=$VIEWROOT
        VIEWNAME="$LOCALBRANCH <=> $REMOTEBRANCH"
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
