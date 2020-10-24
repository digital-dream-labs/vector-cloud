# Quick install notes.

1.  Locally run 'go build process/main.go' so that external
    dependencies are fetched via github.

2.  Build a custom docker image to enable cross compiling. `make docker-builder`

3.  `make vic-cloud`