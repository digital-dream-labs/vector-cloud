.PHONY: docker-builder vic-cloud vic-gateway

docker-builder:
	docker build -t armbuilder docker-builder/.

all: vic-cloud vic-gateway

vic-cloud:
	docker container run -it --rm \
	-v "$(PWD)":/go/src/digital-dream-labs/vector-cloud \
	-v $(GOPATH)/pkg/mod:/go/pkg/mod \
	-w /go/src/digital-dream-labs/vector-cloud \
	--user $(UID):$(GID) \
	armbuilder \
	go build  \
	-tags nolibopusfile,vicos \
	--trimpath \
	-ldflags="-w -s -linkmode internal -extldflags -static" \
	-o build/vic-cloud \
	process/main.go

	docker container run -it --rm \
	-v "$(PWD)":/go/src/digital-dream-labs/vector-cloud \
	-v $(GOPATH)/pkg/mod:/go/pkg/mod \
	-w /go/src/digital-dream-labs/vector-cloud \
	--user $(UID):$(GID) \
	armbuilder \
	upx build/vic-cloud


vic-gateway:
	docker container run -it --rm \
	-v "$(PWD)":/go/src/digital-dream-labs/vector-cloud \
	-v $(GOPATH)/pkg/mod:/go/pkg/mod \
	-w /go/src/digital-dream-labs/vector-cloud \
	--user $(UID):$(GID) \
	armbuilder \
	go build  \
	-tags nolibopusfile,vicos \
	--trimpath \
	-ldflags="-w -s -linkmode internal -extldflags -static" \
	-o build/vic-gateway \
	gateway/*.go

	docker container run -it --rm \
	-v "$(PWD)":/go/src/digital-dream-labs/vector-cloud \
	-v $(GOPATH)/pkg/mod:/go/pkg/mod \
	-w /go/src/digital-dream-labs/vector-cloud \
	--user $(UID):$(GID) \
	armbuilder \
	upx build/vic-gateway
