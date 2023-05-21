APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=gcr.io/k8s-k3s-9464
VERSION=v1.0.6-$(shell git rev-parse --short HEAD)
TARGETOS=$(shell cat os.txt)#linux 
TARGETARCH=$(shell cat tarch.txt)  #arm64

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
	echo 'linux' > os.txt
	echo 'amd64' > tarch.txt
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-amd64

arm:
	echo 'darwin' > os.txt
	echo 'arm64' > tarch.txt
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-arm64

macos:
	echo 'darwin' > os.txt
	echo 'amd64' > tarch.txt
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-amd64

windows:
	echo 'windows' > os.txt
	echo 'amd64' > tarch.txt
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-amd64
