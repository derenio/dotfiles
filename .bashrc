# /etc/skel/.bashrc
# # This file is sourced by all *interactive* bash shells on startup, # including some apparently interactive shells such as scp and rcp # that can"t tolerate any output.  So make sure this doesn"t display # anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it"s important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Put your fun stuff here.
indeks="i209116"
port="49152"
ii_tunnel="ssh -N -L $port:hera:22 $indeks@tryglaw.ii.uni.wroc.pl"

function hera {
    pgrep -f -x "$ii_tunnel" &> /dev/null
    if [[ $? -ne 0 ]]; then
        $ii_tunnel &
        sleep 4
    fi
    ssh $indeks@localhost -p $port
}

function hera_send {
    if [[ $1 == "" ]]; then echo "hera_send plik [katalog_na_serwerze]"; return; fi
    pgrep -f -x "$ii_tunnel" &> /dev/null
    if [[ $? -ne 0 ]]; then
        $ii_tunnel &
        sleep 4
    fi
    scp -P $port $1 $indeks@localhost:~/$2
}

function hera_dl {
    if [[ $1 == "" ]]; then echo "hera_dl plik_na_serwerze [katalog]"; return; fi
    pgrep -f -x "$ii_tunnel" &> /dev/null
    if [[ $? -ne 0 ]]; then
        $ii_tunnel &
        sleep 4
    fi
    if [[ $2 == "" ]]; then to_where="."; else to_where=$2; fi
    scp -P $port $indeks@localhost:~/$1 $to_where
}

function tryglaw_send {
    scp $1 $indeks@tryglaw.ii.uni.wroc.pl:~/$2
}

function tryglaw_dl {
    if [[ $2=="" ]]; then to_where="."; else to_where=$2; fi
    scp $indeks@tryglaw.ii.uni.wroc.pl:~/$1 $to_where
}

function hdparm-set_acpi {
    sudo hdparm -B $1 /dev/sda
}

function hddtemp {
    sudo /usr/sbin/hddtemp /dev/sda
}

function evince {
	/usr/bin/evince "$@" &
}

function smplayer {
	/usr/bin/smplayer "$@" &
}

function gtime {
	/usr/bin/time "$@"
}

function fnd {
	unset _path _args _name
	if [ $# -eq 1 ]
	then
		_path='.'
		_name=$1
	else
		for x in "$@"; do
			if [[ $x == -* ]]
			then
				_args+="$x "
			else
				if [ -z "$_name" ]
				then
					_name=$x
				else
					_path=$x
				fi
			fi
		done;
	fi

	find $_path $_args -iregex ".*$_name.*"
	unset _path _args _name
}

function grepdir {
	unset _path _args _name
	_path='.'
	if [ $# -eq 1 ]
	then
		_name=$1
	else
		for x in "$@"; do
			if [[ $x == -* ]]
			then
				_args+="${x:1}"
			else
				if [ -z "$_name" ]
				then
					_name=$x
				else
					_path=$x
				fi
			fi
		done;
	fi
	if [ -n "$_args" ]
	then _args="-$_args"
	else _args="-nI"
	fi

	#echo "find $_path -type f -exec grep $_args --color=auto $_name {} +"
	find "$_path" -type f -exec grep "$_args" --color=auto "$_name" {} +
	unset _path _args _name
}

function update_vim_git {
    # pull the changes
	cd ~/.vim/bundle/
	ls | xargs -n1 -I{} bash -c 'cd "$1"; git pull; echo' -- {}
	cd -
	# making the command-t's ruby extention
	cd ~/.vim/bundle/Command-T/ruby/command-t/ext/command-t
	ruby extconf.rb
	make clean
	make
	cd -
	# installing tern for tern_for_vim
	cd ~/.vim/bundle/tern_for_vim
	npm install
	cd -
}

function dush {
	# du -s ${1:-.}/* | sort -n | cut -f2 | xargs -d'\n' -n1 du -sh
	in="${1:-.}"
	if [ "${in: -1}" = '/' ]; then
		in="${in:0: -1}"  # strip trailing '/'
	fi
	du -sch "${in}"/* | sort -h
}

# Remove previous command from the history - pon, 24 lis 2014, 13:22:34 CET
# Changed into function Wed Jun 10 14:23:39 CEST 2015
function rh {  # mnemonic: remove-history
	history -a
	hist_size=$(wc -l ~/.bash_history | cut -d\  -f1)
	# ADDENDUM we ignore the rh command with HISTIGNORE
	#    # WARNING don't use with leading space - > rh<
	#    # it will remove 2 history entrances in that case.
	#    second_to_last_line_number=$(( $hist_size - 1 ))
	#    sed -i "$second_to_last_line_number,\$d" ~/.bash_history
	sed -i "$hist_size,\$d" ~/.bash_history
	history -c
	history -r
}
# https://stackoverflow.com/questions/1904860/how-to-remove-unreferenced-blobs-from-my-git-repo
function git-gc-all {
	git -c gc.reflogExpire=0 -c gc.reflogExpireUnreachable=0 -c gc.rerereResolved=0 -c gc.rerereUnresolved=0 -c gc.pruneExpire=now gc "$@"
}

alias eh="history -a; /usr/bin/vim ${HOME}/.bash_history; history -c; history -r"  # mnemonic: edit history
alias editb="/usr/bin/vim ${HOME}/.bashrc"  # mnemonic: edit bashrc
alias sb="source ${HOME}/.bashrc"  # mnemonic: source bashrc
alias ev="/usr/bin/vim ${HOME}/.vimrc"  # mnemonic: edit vimrc
alias gvs='gvim -S .Session.vim'

# git aliases
alias gg="git grep -n"
alias gd="vim .git/index"
alias gst="git status"
alias grc="git rebase --continue"
function gri { if [ -z "%1" ]; then git rebase --interactive; else git rebase --interactive HEAD~"$1"; fi }
alias grm="git rebase master"
alias gss="git stash show -v"
alias gsp="git stash pop"
alias gfu="git checkout master && git fetch -p --all && (git merge --ff-only upstream/master || git pull)"
alias gdfu="git checkout develop && git fetch -p --all && git merge --ff-only upstream/develop"
alias gwip="git add . && git commit -m WIP"
alias gunwip="git reset HEAD^"
alias pip_update="pip list --user --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install --user -U"

# Ignoring not important commands from the bash's history
HISTIGNORE="rm*:cd:cd ..:ls:ll:lal:fg:pwd:jobs:su -:ipython*:cmus:vim:gvim:vim :gvim :"  # basic building commands
HISTIGNORE+=":h1:rh:eh:editb*:sb:ev:grunt:dush*:gvs*:"  # custom commands
HISTIGNORE+=":git st:git b:git d:gfu*:gst:gri*:grm*:grc:gss:gsp:gwip*:gunwip*:"  # git aliases
HISTIGNORE+=":git diff:git gui:gitk:"  # git commands
HISTIGNORE+=":git pull*:git push*:git fetch*:git stash*:git add*:git branch*:git mergetool*:git clean*:"  # git commands' prefixes
export HISTIGNORE

alias n4="adb -s 05101816d8d2c484"
alias n7="adb -s 015d2bc671302008"
alias xz1="adb -s BH9017GQ8Z"
alias gts3="adb -s 3eaeea64"
alias desirez="adb -s HT115RT00878"
alias adbe="adb -s emulator-5554"
alias f3="adb -s 4860e35"
alias f3s="f3 shell"

XZ1_SDCARD_PATH="/storage/A4B1-ABF2"

GTS3_SDCARD_PATH="/storage/0F31-354E"
function gts3p {
	gts3 push "$1" "${GTS3_SDCARD_PATH}"/archive/${2:-}
}

F3_SDCARD_PATH="/storage/self/primary"
function f3p {
	f3 push "$1" "${F3_SDCARD_PATH}"/archive/${2:-}
}

function f3pa {
	for i in "$@"
	do
		f3 push "$i" "${F3_SDCARD_PATH}"/archive/
	done
}

function f3up {
	echo 'input keyevent 26 ; exit' | f3 shell
}

function f3bat {
	echo 'dumpsys battery ; exit' | f3 shell
	#echo 'cat /sys/class/power_supply/battery/uevent ; exit' | f3 shell
}

function f3wifiOn {
	echo 'svc wifi enable ; exit' | f3 shell
}

function f3wifiOff {
	echo 'svc wifi disable ; exit' | f3 shell
}

function f3bluetoothOn {
	echo 'su -c "service call bluetooth_manager 6" ; exit' | f3 shell
}

function f3bluetoothOff {
	echo 'su -c "service call bluetooth_manager 8" ; exit' | f3 shell
}

function f3brightness {
	echo "settings put system screen_brightness $1" | f3 shell
}

function update_typings {
	# First update the global non-dev packages
	typings ls 2>/dev/null | grep '(global)$' | awk '$2 ~ /.+/ {print $2}' | xargs -I {} typings install dt~{} --global --save
	# Then the global dev
	typings ls 2>/dev/null | grep '(global dev)$' | awk '$2 ~ /.+/ {print $2}' | xargs -I {} typings install dt~{} --global --save-dev
}

function clean_vim_undo {
	(
		cd ~/.vim/undo
		for undo_file in *
		do
			[ -e "${undo_file}" ] || continue
			real_file=$(echo "${undo_file}" | sed 's:%:/:g')
			[ -e "${real_file}" ] || rm -f -- "${undo_file}"
		done
	)
}

function stopwatch {
# https://superuser.com/questions/611538/is-there-a-way-to-display-a-countdown-or-stopwatch-timer-in-a-terminal
	date1=`date +%s`
	while true; do
		echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"
		sleep 1
	done
}

#unset use_color safe_term match_lhs
#alias rm="rm -i"
#alias mv="mv -i"
#alias cp="cp -i"
#alias v="vim"
#alias gv="gvim"
#alias ls="ls --color=auto"
#alias la="ls -a"
#alias ll="ls -alh"
#alias grep="grep --colour=auto"
#alias mhz="cat /proc/cpuinfo | grep "cpu MHz""
#alias bat="cat /proc/acpi/battery/BAT1/state | grep "remaining capacity:""
#alias man="LC_MESSAGES="pl_PL.utf8" man"
#set -o vi
alias g=grep # shortcut for grep

alias halt="xfce4-session-logout -h"
alias reboot="xfce4-session-logout -r"
alias ii_tunnel="$ii_tunnel"
alias ii_hera="ssh $indeks@localhost -p $port"
alias tryglaw="ssh $indeks@tryglaw.ii.uni.wroc.pl -p22"
alias spock="ssh -t derenio@spock.jasminek.net screen -dr"
alias filemon_old="ssh -t filemon1 screen -U -dR"
alias filemon="ssh -t filemon screen -U -dR"
alias h1="ssh -t h1 screen -U -dR"
alias ngserver="java -cp ~/.vim/vimclojure/server-2.2.0.jar:/usr/share/clojure-1.2/lib/clojure.jar vimclojure.nailgun.NGServer 127.0.0.1"
alias perlrl="rlwrap perl"
alias perl_repl="rlwrap perl_repl"
alias clojurerl="rlwrap clojure-1.2"
alias m5='md5sum'

# turn off xon/xoff coliding with 'i-search' - <C-s>
stty -ixon

PATH=${PATH}:${HOME}/bin
PATH=${PATH}:${HOME}/misc/android-sdk-update-manager/tools/
PATH=${PATH}:${HOME}/misc/android-sdk-update-manager/tools/bin/
PATH=${PATH}:${HOME}/misc/android-sdk-update-manager/platform-tools/
PATH=${PATH}:${HOME}/misc/android-ndk-r14-beta1/
#PATH=${PATH}:${HOME}/.gem/ruby/2.4.0/bin/
PATH=${PATH}:${HOME}/.local/bin/
PATH=${PATH}:${HOME}/misc/android-studio/bin/
PATH=${PATH}:${HOME}/Dropbox/gfl/bin/
export PATH

export SHELL=/bin/bash

case ${TERM} in
	screen*)
		#set -o functrace
		#trap 'echo -n -e "\033k${BASH_COMMAND}\033\0134"' DEBUG
		#export PROMPT_COMMAND='echo -n -e "\033k\033\0134\033k${HOSTNAME}[`basename ${PWD}`]\033\0134"'
	;;
esac

#LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/cuda/lib64
#export LD_LIBRARY_PATH

PGHOST=localhost; export PGHOST
PGUSER=postgres; export PGUSER
CDPATH=".:/:$HOME"; export CDPATH
PYTHONSTARTUP="$HOME/.pythonrc.py"; export PYTHONSTARTUP
# Moved directly into the .vimrc
#PYTHONPATH="$PYTHONPATH:$HOME/.vim/bundle/ropevim/"; export PYTHONPATH
#PYTHONPATH="$PYTHONPATH:$HOME/.local/lib64/python3.6/site-packages/:"
JAVA_OPTS="-Xms512m -Xmx512m"; export JAVA_OPTS
export ANDROID_HOME="/home/derenio/misc/android-sdk-update-manager/"
#export ANDROIDAPI=16
export ANDROIDSDK="/home/derenio/misc/android-sdk-update-manager/"
#export ANDROIDNDK="/home/derenio/misc/android-ndk-r14-beta1"
#export ANDROID_NDK_HOME="${ANDROIDNDK}"
#export ANDROIDNDKVER=r14-beta1

export BC_ENV_ARGS="${HOME}/.bc"

if [[ $TERM != screen* ]]; then
	if [ -e /usr/share/terminfo/x/xterm-256color ]; then
			export TERM='xterm-256color'
	else
			export TERM='xterm-color'
	fi
fi

#git prompt
source /usr/share/git/git-prompt.sh

# Source this machine's specific commands
source "${HOME}/.bashrc_local"

if [ -n "$BASH_POST_RC" ]; then
	local_bash_post_rc="$BASH_POST_RC"
	# unset the exported variable to make sure any subshell won't run it
	unset BASH_POST_RC
fi
if [ -n "$local_bash_post_rc" ]; then
	eval "$local_bash_post_rc"
fi

function to_pdf {
	for i in "$@"
	do
		convert "$i" -auto-orient "$i.pdf"
	done
}
