all: compile

compile:
	@cd src && moonc -t ../app .

build: compile
	@mkdir -p build

opk: build
	mksquashfs app build/2048.opk -all-root -noappend -no-exports -no-xattrs

love: build
	cd app && zip -9 -r ../build/2048.love .

dev: compile
	@cd src && moonc -t ../app -w .

run: compile
	love app
