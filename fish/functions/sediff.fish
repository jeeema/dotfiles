function sediff
	set expression $argv[1]
	set file $argv[2]
	sed -E $expression $file | diff $file -
end
