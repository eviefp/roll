package = backend

stack_yaml = STACK_YAML="stack.yaml"
stack = $(stack_yaml) stack

build:
	$(stack) build $(package)

ghci:
	$(stack) ghci $(package):lib

test:
	$(stack) test $(package)

ghcid:
	ghcid -a -c "stack ghci $(package):lib --test --ghci-options='-fobject-code -fno-warn-unused-do-bind -Wno-type-defaults' --main-is $(package):$(package)"

postgres:
	nix-shell ./postgres-shell.nix

dev-deps:
	stack build ghcid

.PHONY : build build-dirty run install ghci test test-ghci ghcid dev-deps
