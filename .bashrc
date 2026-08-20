# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Source global definitions (for Red Hat-family distros)
if [ -r /etc/bashrc ]; then
	# shellcheck disable=SC1091
	. /etc/bashrc
fi

# don't put duplicate lines or lines starting with space in the history.
# erase duplicate commands
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=100000

# include datetime in history
export HISTTIMEFORMAT="%Y-%m-%d %T "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# prompt
if command -v starship >/dev/null 2>&1; then
	# https://starship.rs/guide/#step-2-set-up-your-shell-to-use-starship
	command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"
else
	# set a fancy prompt (non-color, unless we know we "want" color)
	case "$TERM" in
	xterm-color | *-256color) color_prompt=yes ;;
	esac

	# uncomment for a colored prompt, if the terminal has the capability; turned
	# off by default to not distract the user: the focus in a terminal window
	# should be on the output of commands, not on the prompt
	#force_color_prompt=yes

	if [ -n "$force_color_prompt" ]; then
		if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
			# We have color support; assume it's compliant with Ecma-48
			# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
			# a case would tend to support setf rather than setaf.)
			color_prompt=yes
		else
			color_prompt=
		fi
	fi

	if [ "$color_prompt" = yes ]; then
		PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	else
		PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
	fi
	unset color_prompt force_color_prompt

	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
	xterm* | rxvt*)
		PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
		;;
	*)
		;;
	esac
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
	. "$HOME/.bash_aliases"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# MY Modification: combined Ubuntu's default with https://github.com/scop/bash-completion/blob/main/README.md
if ! shopt -oq posix && [[ $PS1 && ! ${BASH_COMPLETION_VERSINFO:-} ]]; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

export LANG=ja_JP.UTF-8
tabs -4 # Tab-stop must be of length 4!

# ================ Functions ================

# ripgrep->delta
# https://dandavison.github.io/delta/grep.html
rd() {
	rg --json -C 2 "$@" | delta
}

# Yazi wrapper (https://yazi-rs.github.io/docs/quick-start#shell-wrapper)
y() {
	local tmp cwd
	tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd <"$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || return
	command rm -f -- "$tmp"
}

# ================ CLI tools ================

# ble.sh
if [[ "${SHELL##*/}" != 'brush' ]]; then
	if [ -f "$HOME/.local/share/blesh/ble.sh" ]; then
		# shellcheck disable=SC1091
		. -- "$HOME/.local/share/blesh/ble.sh"
	fi
fi

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"

# fnm
if [[ "${SHELL##*/}" != 'brush' ]]; then
	if command -v fnm >/dev/null 2>&1; then
		eval "$(fnm env --use-on-cd --shell bash)"
	fi
fi

# shellcheck disable=SC1091
[ -f "$HOME/.fzf.bash" ] && . "$HOME/.fzf.bash"

# uv (https://docs.astral.sh/uv/getting-started/installation/#shell-autocompletion)
command -v uv >/dev/null 2>&1 && eval "$(uv generate-shell-completion bash)"
command -v uvx >/dev/null 2>&1 && eval "$(uvx --generate-shell-completion bash)"

# https://zellij.dev/documentation/controlling-zellij-through-cli.html#completions
command -v zellij >/dev/null 2>&1 && eval "$(zellij setup --generate-completion bash)"

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"
