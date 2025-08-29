.PHONY: setup-macos
setup-macos:
	${MAKE} setup-fvm-macos
	${MAKE} setup-melos
	${MAKE} setup-grinder
	${MAKE} setup-lcov-macos

.PHONY: setup-windows
setup-windows:
	${MAKE} setup-fvm-windows
	${MAKE} setup-melos
	${MAKE} setup-grinder

.PHONY: setup-fvm-macos
setup-fvm-macos:
	brew tap leoafarias/fvm
	brew install fvm
	fvm install --setup

.PHONY: setup-fvm-windows
setup-fvm-windows:
	choco install fvm
	fvm install --setup

.PHONY: setup-melos
setup-melos:
	fvm dart pub global activate melos
	fvm dart run melos bs

.PHONY: setup-grinder
setup-grinder:
	fvm dart pub global activate grinder

.PHONY: setup-lcov-macos
setup-lcov-macos:
	brew install lcov

.PHONY: upgrade-flutter
upgrade-flutter:
	fvm flutter upgrade
	fvm install