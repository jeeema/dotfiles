function run
	set target $argv[1]
	gcc -o $target $target.c
	./$target
end
