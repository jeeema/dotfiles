function realwhich
	set program $argv[1]
	realpath (which $program)
end
