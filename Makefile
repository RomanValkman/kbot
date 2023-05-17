APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=romanvalkman
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
#TARGETOS=linux #linux 
#TARGETARCH=amd64 #arm64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v
get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/romanvalkman/kbot/cmd.appVersion=${VERSION}

#image:
#	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

linux:
	TARGETOS=linux
	TARGETARCH=amd64
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

arm:
	TARGETOS=ios
	TARGETARCH=arm64
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

macos:
	TARGETOS=ios
	TARGETARCH=amd64
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

windows:
	TARGETOS=windows
	TARGETARCH=amd64
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
