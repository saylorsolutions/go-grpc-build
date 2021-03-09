# Go gRPC Build Environment
Brings Go, Protoc, gRPC, and UPX together into a self-contained build environment.

Currently, getting a running setup for all of these tools is rather interesting. So I wanted to bring everything together into one build environment, without trying to do everything, so it's a little easier to get started.

A lot of thanks and credit to the [base image](https://hub.docker.com/_/golang) creators for putting an awesome setup together!

## How to Use it
If you're familiar with the [base image](https://hub.docker.com/_/golang), then pretend this is the same thing with some additional batteries included, because that's exactly what it is.

### Dependencies
These dependencies will satisfy the requirements of the protobuf compiler tools. Running `go mod tidy` will include the indirect dependencies.
```
module your/module/here

go 1.16

require (
	github.com/golang/protobuf v1.4.3
	google.golang.org/grpc v1.36.0
	google.golang.org/protobuf v1.25.0
)
```

### Run your Make build in place
You can run a build in the container and have the files output to your local working directory by adding a task to your Makefile like this (substituting 'release' with a target that makes sense to you).
```makefile
# Adapted from the example shown in the base image docs
container-build:
	@docker run --rm -v '$(PWD)':/go/src/app -w /go/src/app go-grpc-build:1.16 make release
```

For more details and options see the base image docs.

## Included Tools
This is what is included currently, but let me know if you would like something else added.

* go 1.16 (included in base image)
* GNU make 4.2.1 (included in base image)
* gcc (Debian 8.3.0-6) 8.3.0 (included in base image)
* protoc v3.15.5
* protoc-gen-go v1.25.0
* protoc-gen-go-grpc v1.1.0
* upx 3.96
