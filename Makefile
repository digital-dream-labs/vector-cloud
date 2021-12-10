.PHONY: docker-builder vic-cloud vic-gateway

docker-builder:
	docker build -t armbuilder docker-builder/.

all: vic-cloud vic-gateway

go_deps:
	echo `go version` && cd $(PWD) && go mod download

vic-cloud: go_deps
	docker container run  \
	-v "$(PWD)":/go/src/digital-dream-labs/vector-cloud \
	-v $(GOPATH)/pkg/mod:/go/pkg/mod \
	-w /go/src/digital-dream-labs/vector-cloud \
	--user $(UID):$(GID) \
	armbuilder \
	go build  \
	-tags nolibopusfile,vicos \
	--trimpath \
	-ldflags '-w -s -linkmode internal -extldflags "-static" -r /anki/lib' \
	-o build/vic-cloud \
	cloud/main.go

	docker container run \
	-v "$(PWD)":/go/src/digital-dream-labs/vector-cloud \
	-v $(GOPATH)/pkg/mod:/go/pkg/mod \
	-w /go/src/digital-dream-labs/vector-cloud \
	--user $(UID):$(GID) \
	armbuilder \
	upx build/vic-cloud


vic-gateway: go_deps
	docker container run \
	-v "$(PWD)":/go/src/digital-dream-labs/vector-cloud \
	-v $(GOPATH)/pkg/mod:/go/pkg/mod \
	-w /go/src/digital-dream-labs/vector-cloud \
	--user $(UID):$(GID) \
	armbuilder \
	go build  \
	-tags nolibopusfile,vicos \
	--trimpath \
	-ldflags '-w -s -linkmode internal -extldflags "-static" -r /anki/lib' \
	-o build/vic-gateway \
	gateway/*.go

	docker container run \
	-v "$(PWD)":/go/src/digital-dream-labs/vector-cloud \
	-v $(GOPATH)/pkg/mod:/go/pkg/mod \
	-w /go/src/digital-dream-labs/vector-cloud \
	--user $(UID):$(GID) \
	armbuilder \
	upx build/vic-gateway

upload-on-vector:
	@ssh root@$(ROBOT_IP) "mount -o remount,rw /"
	@ssh root@$(ROBOT_IP) "systemctl stop vic-cloud"
	@ssh root@$(ROBOT_IP) "systemctl stop vic-gateway"
	@scp ./build/vic-cloud root@$(ROBOT_IP):/anki/bin/vic-cloud 
	@scp ./build/vic-gateway root@$(ROBOT_IP):/anki/bin/vic-gateway 
	@ssh root@$(ROBOT_IP) "systemctl daemon-reload"
