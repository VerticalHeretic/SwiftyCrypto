documentation: 
	jazzy \
		--min-acl internal \
		--theme apple \
		--output ./docs \
		--documentation=./*.md
	rm -rf ./build