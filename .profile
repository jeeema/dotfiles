# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# UBUNTU_VERSION=$(lsb_release -rs | head -1)
# if [ "$XDG_SESSION_TYPE" = "wayland" ] && [ "$(echo "$UBUNTU_VERSION < 23.10" | bc)" -eq 1 ]; then
# 	export MOZ_ENABLE_WAYLAND=1
# fi

if [ -n "$WSL_DISTRO_NAME" ]; then
	export PATH="/usr/lib/linux-tools-6.8.0-111${PATH:+:$PATH}"
fi

# CUDA Toolkit
if [ -d '/usr/local/cuda' ]; then
	export PATH=/usr/local/cuda/bin${PATH:+:$PATH}
	export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
	export PATH="$HOME/bin${PATH:+:$PATH}"
fi

case "$(uname -m)" in
x86_64)
	LOCAL_PLATFORM=""
	;;
aarch64) #  for Miyabi-G login node
	LOCAL_PLATFORM="aarch64-linux-gnu"
	;;
*)
	printf 'Unsupported architecture: %s\n' "$(uname -m)" >&2
	LOCAL_PLATFORM=""
	;;
esac

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
	# NOTE: the codes inside this if clause is from $HOME/.local/bin/env script installed by uv's installer
	# add binaries to PATH if they aren't added yet
	# affix colons on either side of $PATH to simplify matching
	case ":${PATH}:" in
	*:"$HOME/.local/bin":*)
		;;
	*)
		# Prepending path in case a system-installed binary needs to be overridden
		if [ -n "$LOCAL_PLATFORM" ]; then
			export PATH="$HOME/.local/bin/$LOCAL_PLATFORM:$HOME/.local/bin${PATH:+:$PATH}"
		else
			export PATH="$HOME/.local/bin${PATH:+:$PATH}"
		fi
		;;
	esac
fi
unset LOCAL_PLATFORM

if [ -f "$HOME/.cargo/env" ]; then
	# shellcheck disable=SC1091
	. "$HOME/.cargo/env"
fi

if command -v hx >/dev/null 2>&1; then
	export EDITOR='hx'
	export HELIX_RUNTIME="$HOME/dotfiles/submodules/helix/runtime"
else
	export EDITOR='vim'
fi

if [ -d "$HOME/go/bin" ]; then
	export PATH="${PATH:+$PATH:}$HOME/go/bin"
fi

if [ -d '/usr/local/go/bin' ]; then
	export PATH="${PATH:+$PATH:}/usr/local/go/bin"
fi

if [ -f "$HOME/.ghcup/env" ]; then
	# shellcheck disable=SC1091
	. "$HOME/.ghcup/env" # ghcup-env
fi

# fnm (Node.js version manager)
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
	export PATH="$FNM_PATH${PATH:+:$PATH}"
fi

# Add ~/modulefiles to Lmod's search path
if command -v module >/dev/null 2>&1; then
	module use "$HOME/modulefiles"
fi

if command -v ghq >/dev/null 2>&1; then
	_GHQ_ROOT="$(ghq root)"
	if [ -d "$_GHQ_ROOT/github.com/AMReX-Codes/amrex" ]; then
		export AMREX_HOME="$_GHQ_ROOT/github.com/AMReX-Codes/amrex"
	fi

	if [ -d "$_GHQ_ROOT/gitlab.com/petsc/petsc" ]; then
		export PETSC_DIR="$_GHQ_ROOT/gitlab.com/petsc/petsc"
	fi
fi

# fzf
# --------
# Display the preview windows above
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
# 	--preview-window=up'

# Use fd to generate input for fzf if available (https://github.com/sharkdp/fd#using-fd-with-fzf)
if command -v fd >/dev/null 2>&1; then
	# Use fd's colored output inside fzf, include hidden files, exclude .git folders
	export FZF_DEFAULT_COMMAND='fd --type file --strip-cwd-prefix --color=always --hidden --exclude .git'
	# Apply the command to CTRL-T as well
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Ayu Dark
# Imperfect since this is almost the same as Ayu Mirage with only bg & fg values modified
# Ayu Mirage: https://github.com/junegunn/fzf/wiki/Color-schemes#ayu-mirage)
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
 --ansi
 --color=fg:#e6e1cf,bg:#0f1419,hl:#707a8c
 --color=fg+:#707a8c,bg+:#191e2a,hl+:#ffcc66
 --color=info:#73d0ff,prompt:#707a8c,pointer:#cbccc6
 --color=marker:#73d0ff,spinner:#73d0ff,header:#d4bfff'
