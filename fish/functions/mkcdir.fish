function mkcdir
	set dir $argv[1]
	mkdir -p $dir
	eval "cd" $dir
end
