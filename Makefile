emu:
	flutter emulators --launch pixel_6

test: 
	flutter test --branch-coverage

covhtml:
	genhtml --no-branch-coverage --no-function-coverage -o covhtml ./coverage/*.info
	xdg-open covhtml/index.html

fmt: 
	dart format .

fix:
	dart fix --apply

deps:
	sudo apt install lcov

.PHONY: test fmt fix emu covhtml deps