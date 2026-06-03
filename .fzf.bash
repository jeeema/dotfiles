# https://github.com/akinomyoga/blesh-contrib/blob/master/integration/fzf.md#option-2-set-up-in-fzfbash

# If ble/contrib/integration/fzf cannot find the fzf directory, please set the
# following variable "_ble_contrib_fzf_base" manually.  The value
# "/path/to/fzf-directory" should be replaced by a path to the fzf directory
# such as "$HOME/.fzf" or "/usr/share/fzf" that contain
# "shell/{completion,key-bindings}.bash" or "{completion,key-bindings}.bash".

#_ble_contrib_fzf_base=/path/to/fzf-directory

# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/dotfiles/submodules/fzf/bin* ]]; then
	export PATH="${PATH:+${PATH}:}$HOME/dotfiles/submodules/fzf/bin"
fi

# Auto-completion
# ---------------
if [[ $- == *i* ]]; then
	# Note: If you would like to combine fzf-completion with bash_completion, you
	# need to load bash_completion earlier than fzf-completion.

	#source -- /path/to/bash_completion.sh

	if [[ ${BLE_VERSION-} ]]; then
		ble-import integration/fzf-completion
	fi
fi

# Key bindings
# ------------
if [[ ${BLE_VERSION-} ]]; then
	ble-import integration/fzf-key-bindings
fi

if [[ -z ${BLE_VERSION-} ]]; then
	if command -v fzf >/dev/null 2>&1; then
		# Set up fzf key bindings and fuzzy completion
		# $(fzf --bash) is equivalent to $(cat fzf/shell/completion.bash fzf/shell/keybindings.bash)
		eval "$(fzf --bash)"
	fi
fi

# Useful functions

# https://junegunn.github.io/fzf/tips/ripgrep-integration/
# ripgrep->fzf->edit (Helix or Vim) [QUERY]
rfe() (
	local RELOAD OPENER MULTIFLAG

	RELOAD='reload:rg --column --color=always --smart-case {q} || :'

	if [[ "${EDITOR:-}" == *hx ]]; then
		MULTIFLAG='--no-multi'
		# shellcheck disable=SC2016
		OPENER='hx {1}:{2}'
	else
		MULTIFLAG='--multi'
		# shellcheck disable=SC2016
		OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
	            vim {1} +{2}     # No selection. Open the current line in Vim.
	          else
	            vim +cw -q {+f}  # Build quickfix list for the selected items.
	          fi'
	fi

	fzf --disabled --ansi "$MULTIFLAG" \
		--bind "start:$RELOAD" --bind "change:$RELOAD" \
		--bind "enter:become:$OPENER" \
		--bind "ctrl-o:execute:$OPENER" \
		--bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
		--delimiter : \
		--preview 'bat --style=full --color=always --highlight-line {2} {1}' \
		--preview-window '~4,+{2}+4/3,<80(up)' \
		--query "$*"
)
