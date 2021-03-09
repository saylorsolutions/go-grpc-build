FROM golang:1.16

ARG PROTOC_VERSION=3.15.5
ARG PROTOC_GEN_GO_VERSION=v1.25.0
ARG PROTOC_GEN_GO_GRPC_VERSION=v1.1.0
ARG UPX_VERSION=3.96

ENV PROTOC_VERSION=${PROTOC_VERSION} \
    PROTOC_GEN_GO_VERSION=${PROTOC_GEN_GO_VERSION} \
    PROTOC_GEN_GO_GRPC_VERSION=${PROTOC_GEN_GO_GRPC_VERSION} \
    UPX_VERSION=${UPX_VERSION}

RUN apt update && \
    apt install -y zip xz-utils

WORKDIR "/init"
COPY ["init.sh", "/init/"]

RUN bash -c /init/init.sh

CMD tail -f /dev/null
