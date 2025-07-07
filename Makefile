GO?=go

# Get the currently used golang install path (in GOPATH/bin, unless GOBIN is set)
ifeq (,$(shell go env GOBIN))
GOBIN=$(shell go env GOPATH)/bin
else
GOBIN=$(shell go env GOBIN)
endif

BINARY_NAME=token-sync-controller
# TODO less bruteforce ?
BINARY_FILES=$(shell find ${PWD} -type f -name "*.go")
GOFMT_FILES?=$(shell find . -not -path "./vendor/*" -type f -name '*.go')

VERSION ?= $(shell git describe --match 'v[0-9]*' --dirty='.m' --always)
REVISION=$(shell git rev-parse HEAD)$(shell if ! git diff --no-ext-diff --quiet --exit-code; then echo .m; fi)
PKG=github.com/wiremind/token-sync-controller

# Control if static or dynamically linked (static by default)
export CGO_ENABLED:=0

GO_GCFLAGS?=
GO_LDFLAGS=-ldflags '-X $(PKG)/version.Version=$(VERSION) -X $(PKG)/version.Revision=$(REVISION) -X $(PKG)/version.Package=$(PKG)'

.PHONY: build
build: ${BINARY_NAME}

${BINARY_NAME}: ${BINARY_FILES}
	${GO} build ${GO_GCFLAGS} ${GO_LDFLAGS} -o $@ cmd/${BINARY_NAME}/main.go
	strip -x $@

## Lints all the go code in the application.
.PHONY: lint
lint:
	gofmt -w $(GOFMT_FILES)
	$(GOBIN)/goimports -w $(GOFMT_FILES)
	$(GOBIN)/gofumpt -l -w $(GOFMT_FILES)
	$(GOBIN)/gci write $(GOFMT_FILES) --skip-generated
	$(GOBIN)/golangci-lint run

## Loads all the dependencies to vendor directory
.PHONY: dependencies
dependencies:
	go install golang.org/x/tools/cmd/goimports@v0.34.0
	go install mvdan.cc/gofumpt@v0.8.0
	go install github.com/daixiang0/gci@v0.13.6
	go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@v2.2.1
	go mod vendor
	go mod tidy
