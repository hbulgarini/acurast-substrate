ZOMBINET_VERSION := v1.3.53

UNAME_S := $(shell uname -s)

ZOMBINET_PATHS := ${PATH}:${PWD}/zombienet/bin

touch_done=@mkdir -p $(@D) && touch $@;

ifeq ($(UNAME_S), Linux)
ZOMBINET_BIN := zombienet-linux-x64
endif
ifeq ($(UNAME_S), Darwin)
ZOMBINET_BIN := zombienet-macos
endif

all: download-zombienet

download-zombienet: $(ZOMBINET_BIN:%=zombienet/bin/%)

zombienet/bin/%:
	@echo "Downloading https://github.com/paritytech/zombienet/releases/download/${ZOMBINET_VERSION}/$*"
	@curl -L -o zombienet/bin/$* https://github.com/paritytech/zombienet/releases/download/${ZOMBINET_VERSION}/$*
	@chmod +x zombienet/bin/$*

export PATH = $(ZOMBINET_PATHS)
start: all
	@zombienet/bin/${ZOMBINET_BIN} spawn zombienet/config.toml

build-release:
	@cargo build --release

check-release:
	@cargo check --release

export TAG := eu.gcr.io/papers-dev-kubernetes/papers/acurast/acurast-substrate:latest
docker-build:
	@docker build -t $(TAG) .
