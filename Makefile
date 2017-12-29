.DEFAULT_GOAL := build-all

export GO15VENDOREXPERIMENT=1

UNAME_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')

GO_BUILD := go build -i
GO_TEST  := go test

ifeq ($(UNAME_S),Linux)
GO_BUILD += -tags "cgo_jemalloc"
GO_TEST  += -tags "cgo_jemalloc"
build-deps: build-jemalloc
endif

build-all: redis-sync redis-dump redis-decode redis-replay

build-deps: build-jemalloc
	@mkdir -p bin && bash version

redis-sync: build-deps
	@echo TODO $@

redis-dump: build-deps
	@echo TODO $@

redis-decode: build-deps
	@echo TODO $@

redis-replay: build-deps
	@echo TODO $@

clean:
	@rm -rf bin

distclean: clean
	@make distclean --no-print-directory --quiet -C third_party/redis
	@[ ! -f third_party/jemalloc/Makefile ] || \
		make distclean --no-print-directory --quiet -C third_party/jemalloc

gotest: build-deps
	${GO_TEST} -v ./pkg/...

jemalloc:
	@pushd third_party/jemalloc && \
		./autogen.sh --with-jemalloc-prefix="je_" && make -j

build-jemalloc:
	@[ -f third_party/jemalloc/lib/libjemalloc_pic.a ] || \
		make jemalloc --no-print-directory
