documentation: 
	jazzy \
		--clean \
		--author LSWarss \
		--source-host github \
		--source-host-url https://github.com/LSWarss/SwiftyCrypto \
		--min-acl internal \
		--theme apple \
		--output ./docs \
		--documentation=./*.md
	rm -rf ./build
