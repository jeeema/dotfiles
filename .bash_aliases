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

# zoxide into ghq repository
alias zor='cd $(ghq list --full-path | fzf)'

# clipboard
if [[ ${WSL_DISTRO_NAME:-} ]]; then
	# WSL (Windows)
	alias open='explorer.exe'
	alias clip='clip.exe'
else
	# Linux (Wayland)
	alias clip='wl-copy'
fi

if [[ ${PETSC_DIR:-} ]]; then
	alias petscmpiexec='$PETSC_DIR/lib/petsc/bin/petscmpiexec'
	alias petscversion='$PETSC_DIR/lib/petsc/bin/petscversion'
fi

# Intel oneAPI
if [[ -f '/opt/intel/oneapi/setvars.sh' ]]; then
	alias loadintel='. /opt/intel/oneapi/setvars.sh'
fi

# AMD machine
readonly AOCC_VERSION='5.1.0'
readonly AOCL_VERSION='5.2.0'
if [[ -f /opt/AMD/aocc-compiler-$AOCC_VERSION/setenv_AOCC.sh && -f /opt/AMD/aocl/aocl-linux-aocc-$AOCL_VERSION/aocc/amd-libs.cfg ]]; then
	alias loadamd='. /opt/AMD/aocc-compiler-$AOCC_VERSION/setenv_AOCC.sh && . /opt/AMD/aocl/aocl-linux-aocc-$AOCL_VERSION/aocc/amd-libs.cfg'
fi
