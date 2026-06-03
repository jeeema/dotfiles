if status is-interactive
    # Commands to run in interactive sessions can go here
    abbr less 'less -MN'
    abbr l eza
    abbr cac 'cargo atcoder'
    abbr --set-cursor s 'sed -E \'%\''
    abbr e emacsclient -c
    abbr cp cp -i
    abbr mv mv -i
    abbr --set-cursor tree 'fd % | as-tree'
    abbr sc systemctl
    abbr explorer /mnt/c/Windows/explorer.exe
    abbr uvjlab 'uv run jupyter lab'
    abbr amrvis2d ~/src/Amrvis/amrvis2d.llvm.TRACE_PROF.ex

    #https://blog.matzryo.com/entry/2018/09/02/cd-then-ls-with-fish-shell
    # functions --copy cd standard_cd
    # function cd
    #     standard_cd $argv; and eza
    # end

end

fzf --fish | source
zoxide init fish | source
direnv hook fish | source
