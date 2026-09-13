# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# ls/eza aliases
if command -v eza >/dev/null 2>&1; then
	alias el='ls --color=auto -alF'
	alias ea='ls --color=auto -A'
	alias e='ls --color=auto -CF'
else
	alias el='ls --color=auto -alF'
	alias ea='ls --color=auto -A'
	alias e='ls --color=auto -CF'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# TODO: unable to do this in WSL2
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias cp='cp -i'
alias mv='mv -i'

# some git aliases
alias gst='git status'
alias glg='git log'

# zoxide into ghq repository
alias zor='cd $(ghq list --full-path | fzf)'

# clipboard
if [[ ${WSL_DISTRO_NAME:-} ]]; then
	# WSL (Windows)
	alias open='/mnt/c/Windows/explorer.exe'
	alias clip='/mnt/c/Windows/System32/clip.exe'
else
	# Linux (Wayland)
	alias clip='wl-copy'
fi

if [[ ${PETSC_DIR:-} ]]; then
	alias petscmpiexec='$PETSC_DIR/lib/petsc/bin/petscmpiexec'
	alias petscversion='$PETSC_DIR/lib/petsc/bin/petscversion'
fi

# ================ Functions ================

# AMD machine
loadamd() {
	local -r aocc_version='5.2.0'
	local -r aocl_version='5.3.0'

	local aocc_env="/opt/AMD/aocc-compiler-$aocc_version/setenv_AOCC.sh"
	local aocl_env="/opt/AMD/aocl/aocl-linux-aocc-$aocl_version/aocc/amd-libs.cfg"

	if [[ -f $aocc_env && -f $aocl_env ]]; then
		. "$aocc_env" && . "$aocl_env"
	else
		printf 'AOCC/AOCL environment files not found\n' >&2
		return 1
	fi
}

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
