
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#-------------------------------------------------------------
# Various Utilities
#-------------------------------------------------------------

# cd and then list
cdl () { cd "$@" && l; }

# extract - archive extraction

extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "Unrecognized file extension for '$1'" ;;
       esac
   else
       echo "'$1' is not a valid file"
   fi
}

# netaddr - show addresses

netaddr () {
    if [[ -z "$1" ]];then
        netsh interface ip show addresses
    else
        netsh interface ip show addresses "$1"
    fi
}

# netdiag - diagnose network

netdiag () {
    ipconfig -release
    ipconfig -renew
    arp -d *
    nbtstat -R
    nbtstat -RR
    ipconfig -flushdns
    ipconfig -registerdns
}

# netreset - reset an adapter

netreset () { 
    if [[ -z "$1" ]];then
        echo "Disabling Wi-Fi interface"
        netsh interface set interface "Wi-Fi" DISABLED
        echo "Enabling Wi-Fi interface"
        netsh interface set interface "Wi-Fi" ENABLED
    else
        echo "Disabling $1 interface"
        netsh interface set interface "$1" DISABLED
        echo "Enabling $1 interface"
        netsh interface set interface "$1" ENABLED
    fi
}

# restartaudio - restart audio services

audiorestart () {
    cmd "net stop audiosrv"
    cmd "net stop AudioEndpointBuilder"
    cmd "net start audiosrv"
}

# cpg - copy and go to dir

cpg (){
    if [ -d "$2" ];then
        cp $1 $2 && cd $2
    else
        cp $1 $2
    fi
}

# mvg - move and go to dir

mvg (){
    if [ -d "$2" ];then
        mv $1 $2 && cd $2
    else
        mv $1 $2
    fi
}

# search - search for given pattern in all files in all dirs in current directory

search (){
    if [ ! -z $2 ];then
        grep --colour=always --exclude-dir=".git" -rn "$2" -e "$1" |  sed -re  's/^([^:]+):(\x1b\[m\x1b\[K)[[:space:]]*(.*)/\1\x01\2\3/' | column -s $'\x01' -t
    else
        grep --colour=always --exclude-dir=".git" -rn "./" -e "$1" |  sed -re  's/^([^:]+):(\x1b\[m\x1b\[K)[[:space:]]*(.*)/\1\x01\2\3/' | column -s $'\x01' -t
    fi
}

# filesize - get the size of a file in bytes

filesize() {
    if [ ! -z $1 ];then
        wc -c < $1
    else
        echo "Usage: filesize [filename]"
    fi
}

#-------------------------------------------------------------
# ls colors and aliases
#-------------------------------------------------------------

LS_COMMON="-hG --group-directories-first"
LS_COMMON="$LS_COMMON --color=auto"
LS_COMMON="$LS_COMMON -I NTUSER.DAT\* -I ntuser.dat\* -I ntuser.ini\* -I desktop.ini\*"

test -n "$LS_COMMON" &&
alias ls="command ls $LS_COMMON"
alias l="ls -l"
alias ll="ls -l"
alias lg="ls -g"
alias la="ls -a"
alias lal="ll -a"
alias lla="ll -a"

LS_COLORS='di=1;36:fi=0:ln=1;30:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=1;32:*.rpm=90'
export LS_COLORS

#-------------------------------------------------------------
# bash aliases
#-------------------------------------------------------------

# misc
alias c='clear'
alias g++="g++ --std=c++0x"

# directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ..l='cd ..;l'

# edit config shortcuts 
alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bash_profile'
alias bashreload='source ~/.bash_profile'

# git shortcuts
alias gti='git'
alias gt='git'
alias gi='git'
alias gs='git status'
alias ga='git add'
alias gl='git pull'
alias gp='git push'
alias gc='git commit -m'
alias gca='git commit -am'
alias gd='git diff'
alias gco='git checkout'
alias glog='git log'
alias glogp='git log --pretty=format:"%h %s" --graph'

if [ -f ~/bash_aliases ]; then
      . ~/bash_aliases
fi