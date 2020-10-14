vic-cloud:
	CGO_ENABLED=1 CGO_LDFLAGS=-lopus \
	CGO_FLAGS="-g -march=armv7-a" \
	CC=arm-linux-gnueabi-gcc \
	CGO_CPPFLAGS="-I /usr/arm-none-eabi/include" \
	GOOS=linux GOARCH=arm GOARM=7 \
	go build \
	-o vic-cloud \
	process/main.go
