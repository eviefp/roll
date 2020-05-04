package = backend

stack_yaml = STACK_YAML="stack.yaml"
stack = $(stack_yaml) stack

build:
	$(stack) build $(package)

ghci:
	$(stack) ghci $(package):lib

test:
	$(stack) test $(package)

run: build pg-restart
	$(stack) exec -- $(package)

ghcid:
	ghcid -a -c "stack ghci $(package):lib --test --ghci-options='-fobject-code -fno-warn-unused-do-bind -Wno-type-defaults' --main-is $(package):$(package)"

format:
	find src -name "*.hs" -exec floskell {} \;

pg-restart: pg-stop pg-start

pg-start:
	../../script/pg-start.sh

pg-stop:
	../../script/pg-stop.sh

.PHONY : build ghci test ghcid pg-start pg-stop pg-restart format
