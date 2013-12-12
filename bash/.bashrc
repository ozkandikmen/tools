# .bashrc
# This exits if we are non-interactive (fix for scp and the like)
# 2013.01.28: Must keep the following "return" commented out until build (php) scripts
#             are enhanced to source /tools/oss/latest.env_var.sh when it is accessible.
#             Or else, grid based execution (qbuild) does not work, i.e. this file ends
#             up not getting sourced after qbuild ssh's to a build machine.
# 2013.01.29: I noticed that ssh'ing to other fedora machines with the following line
#             commented makes acd_func.sh spew error. However, it is not happening if
#             the line is uncommented. Also, it is not happening as ssh'ing to non-fedora
#             machines either even when the following line is commented.
#[ -z "$PS1" ] && return

# User specific aliases and functions

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
    source /tools/rational/clearcase/latest.env_var.sh

    # Git (git-tool setup to make its use convenient)
    # Handled by /tools/oss/latest.env_var.sh

    # Subversion (rapidsvn is a nice GUI frontend)
    # TODO: Remove the following directory from the system after the data in svn is migrated to git
    #       Dec, 2012: I created /tools/oss/svn/scripts to contain FPGA's svn-tool. See that script for its purpose.
    source /tools/subversion/latest.env_var.sh

    # Open source tools (Cloud/grid, Jedit, git, meld, tig, etc.)
    source /tools/oss/latest.env_var.sh

    # Code Review tools
    source /tools/smartbear/peerreview/latest.env_var.sh

    # Modelsim (Due to name mismatch (vsim), use either aldec or mentor at a time)
    if [ "$sim" == "modelsim" ]; then source /tools/mentor/modelsim/SE/latest.env_var.sh ; fi

    # Aldec Riviera (Due to name mismatch (vsim), use either aldec or mentor at a time)
    if [ "$sim" == "riviera" ]; then source /tools/aldec/riviera/latest.env_var.sh ; fi

    # Visual Elite (now Mentor)
    #source /tools/summit/visual_elite/latest.env_var.sh

    # Synplify
    #source /tools/synplicity/synplify/latest.env_var.sh

    # Quartus
    #source /tools/altera/quartus/latest.env_var.sh

    # ISE (foundation)
    #if [ "$sim" != "riviera" -a $qt_designer == "no" ]; then source /tools/xilinx/ISE/foundation/latest.env_var.sh ; fi

    # Sun Java - to use with jdu
    #source /tools/sun/jre/latest.env_var.sh

    # Acrobat reader
    source /tools/adobe/acrobat/latest.env_var.sh

# gtkterm - Hyperterminal equivalent for linux


#########################
# Aliases
#########################
alias d='ls -lA --color'    # TODO: I did not need to specify --color in ubuntu 10.04 (until Dec 12, 2012). After transitioned to FC17 on Dec 12, I lost colors and I had to add '--color' to get colorful ls output. However, what is the real solution? Is PS1 at fault? If so, why was it working with ubuntu?  Does /etc/bash or some profile in FC17 mess things up?
alias ll='ls -l --color'    # TODO: I did not need to specify --color in ubuntu 10.04 (until Dec 12, 2012). After transitioned to FC17 on Dec 12, I lost colors and I had to add '--color' to get colorful ls output. However, what is the real solution? Is PS1 at fault? If so, why was it working with ubuntu?  Does /etc/bash or some profile in FC17 mess things up?
# Force the confirmation when deleting/overwriting files
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# -R option makes 'less' interpret colors correctly similar to what 'more' does by default,
# however, searching for text becomes not possible.
# -S has to do with line wrapping
# -X prevents less from remembering the content of the screen prior to running it.
# With the LESS env var, 'man' also works like less does.
#alias less='less -R -S'
export LESS="-X -R -S"

# Make grep highlight the matches in its output
alias grep="grep --color"

# My files in $HOME/bin are better than those introduced by /tools/oss/latest.env_var.sh :)
export PATH=$HOME/bin:$PATH

#export PATH="/home/dikmeno/ActiveState/Komodo-IDE-7/bin:$PATH"
export PATH="/home/dikmeno/ActiveState/Komodo-Edit-7/bin:$PATH"
export PATH="/home/dikmeno/bin/eclipse:$PATH"                   # Feb 8, 2013: Until I test out eclim with eclipse (4.2), I need to use my own copy. Let Kavi know if we'd want eclim be part of the master eclipse installer (/opt/eclipse). Also, Veditor is another eclipse plugin, for verilog.
#export PATH="/home-local/dikmeno/ActiveTcl-8.5/bin:$PATH"
#export PATH="/home-local/dikmeno/TclDevKit-5.3/bin:$PATH"
#export PATH="/home-local/dikmeno/SlickEdit/bin:$PATH"
#export PATH="/home-local/dikmeno/git/bin:$PATH"

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

alias ssh='/tools/oss/bin/sshpwd'
alias chd='source ~/bin/chd'

# ssh machines
alias sshdik='ssh ger-dikmeno-linux-1'
#alias ssh1500a='ssh fpga-1500-a-linux'
#alias ssh2200a='ssh fpga-2200-a-linux'
#alias ssh2800c='ssh fpga-2800-c-linux'
#alias ssh2800d='ssh fpga-2800-d-linux'
#alias ssh2800e='ssh fpga-2800-e-linux'
alias ssh3000a='ssh fpga-3000-a-linux'
#alias ssh3000b='ssh fpga-3000-b-linux'
alias ssh06a='ssh fpga-2006-a-linux'    #ssh3000c='ssh fpga-3000-c-linux'
alias ssh07a='ssh fpga-2007-a-linux'    #ssh3000d='ssh fpga-3000-d-linux'
alias ssh08a='ssh fpga-2008-a-linux'    #ssh3160a='ssh fpga-3160-a-linux'
alias ssh10a='ssh fpga-2010-a-linux'    #ssh3330a='ssh fpga-3330-a-linux'
alias ssh11a='ssh fpga-2011-a-linux'    #ssh3460a='ssh fpga-3460-a-linux'
alias ssh12a='ssh fpga-2012-a-linux'
alias ssh13a='ssh fpga-2013-a-linux'
alias ssh13b='ssh fpga-2013-b-linux'

# Scripts (/tools/oss/bin/*) of value are: qbuild, qbash, qhelp.
# Commands of value are qstat, qhost.
alias submit='ssh fpga-01-centos5-5-linux'
alias ssh01='ssh fpga-01-centos5-5-linux'
#alias ssh02='ssh fpga-02-centos5-5-linux'
#alias ssh03='ssh fpga-03-centos5-5-linux'
#alias ssh04='ssh fpga-04-centos5-5-linux'
#alias ssh05='ssh fpga-05-centos5-5-linux'
#alias ssh06='ssh fpga-06-centos5-5-linux'
#alias ssh07='ssh fpga-07-centos5-5-linux'
#alias ssh08='ssh fpga-08-centos5-5-linux'
#alias ssh09='ssh fpga-09-centos5-5-linux'
#alias ssh20='ssh fpga-20-centos5-5-linux'
#alias ssh21='ssh fpga-21-centos5-5-linux'

alias fpga50='ssh fpga-50-redhat7-3-linux'
alias fpga51='ssh fpga-51-redhat3-linux'
alias fpga52='ssh fpga-52-redhat4-linux'

#export PS1='[\[\e[1;31m\]\u\[\e[1;30m\]@\[\e[1;34m\]\h \W\[\e[1;30m\]\$\[\e[0m\]] '

##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
bash_prompt_command() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=25
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
    echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${NEW_PWD/#$HOME/~}\007"

    # This will keep $VIEWROOT updated with the root path of the current Clearcase view
    if [[ $PWD =~ myviews\/ ]]; then
        if [[ $PWD =~ 2510_fpga\/soh ]]; then
            VIEWROOT=`echo ${PWD} | sed -e 's/\(.*2510_fpga\/soh\).*/\1/'`
        else
            VIEWROOT=$PWD
        fi
        if [[ $PWD =~ myviews\/ ]]; then
            VIEWBASE=`echo ${VIEWROOT} | sed -e 's/.*myviews//' -e 's/\/2510_fpga.*//'`
            VIEWNAME=`basename $VIEWBASE`
        else
            VIEWBASE=""
            VIEWNAME=""
        fi
    else
        VIEWROOT=$PWD
        VIEWBASE=""
        VIEWNAME=""
    fi
    export VIEWROOT
    export VIEWBASE
    export VIEWNAME
}

# Add a git-friendly prompt
function parse_git_branch_and_add_brackets {
    # Return text such as '[faraday.dev]'  (without the single quotes) if current dir is within a valid git working-copy for (local) branch faraday.dev
    #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'

    # Return text such as '[faraday.dev <=> origin/mts-bert/faraday]'  (without the single quotes) if current dir is within a valid git working-copy
    # for (local) branch faraday.dev that tracks remote branch mts-bert/faraday (assuming the project has branched at the remote)
    # 'sed' for remote_branch adds the closing bracket, ], only if there is at least one character in the input
    local_branch=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\ <=>\ /'`
    remote_branch=`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null | sed -e 's/\(.\+\)/\1\]/'`
    echo "$local_branch$remote_branch"
}

bash_prompt() {
    case $TERM in
     xterm*|rxvt*|screen*)
         local TITLEBAR='\[\033]0;\u@\h:${NEW_PWD}  <${VIEWNAME}>\007\]'
          ;;
     *)
         local TITLEBAR=""
          ;;
    esac
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

    #PS1="[${UC}\u${EMK}@${EMB}\h \${NEW_PWD}${K}\${NONE}]$ "
    PS1="$TITLEBAR${EMC}[${UC}\u${EMk}@${EMB}\h ${EMB}\${NEW_PWD}${EMC}]${EMg}\$(parse_git_branch_and_add_brackets)${K}${NONE}\\$ "
    # without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
    # extra backslash in front of \$ to make bash colorize the prompt
}

PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt


# This will check if the $HOME/.pwdtemp file exists and will cd to the directory contained within
# and then remove the file
if [ -e $HOME/.pwdtemp ]; then
    if [ -s $HOME/.pwdtemp ]; then
        mypwd=`cat $HOME/.pwdtemp`
        if [ -d $mypwd ]; then
            cd $mypwd
        else
            echo "Warning:  $HOME/.pwdtemp existed, but it contained an invalid directory: $mypwd"
        fi
    else
        echo "Warning:  $HOME/.pwdtemp existed, but it is empty"
    fi
    \rm -f $HOME/.pwdtemp
fi

#--------------------------------------------------------------------------------
# This is required to change screen's socket directory from /tmp
export SCREENDIR=$HOME/.screen/$HOSTNAME
mkdir -p $SCREENDIR
chmod 700 $SCREENDIR

#--------------------------------------------------------------------------------
# Echo an easy to copy line for setting the current display (mainly for updating existing screens)
mkdir -p ~/.curDisplay
alias sourcecurdisplay='source ~/.curDisplay/${HOSTNAME}'
alias updatecurdisplay='echo "export DISPLAY=$DISPLAY" > ~/.curDisplay/${HOSTNAME}'

fromssh=`echo $DISPLAY | grep localhost`
#echo "fromssh:$fromssh"
#if [ "$fromssh" != "" ]; then
if [ -n "$SSH_CLIENT" ] && [ -n "$SSH_TTY" ]; then
    echo "ssh term: export DISPLAY=$DISPLAY"
elif [ "$TERM" == "screen" ]; then
    source ~/.curDisplay/${HOSTNAME}
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
# append to the history file, don't overwrite it
shopt -s histappend

#--------------------------------------------------------------------------------
# Bash cd history
source $HOME/bin/acd_func.sh

#########################
# Source global definitions
#########################
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
alias ll='ls -l --color'    # FPGA compiler machines is overriding this alias. So, override theirs :)

umask 0022
export EDITOR=vim

xrdb $HOME/.Xresources
