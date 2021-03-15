#!/bin/bash

PROTOC_ZIP=protoc-${PROTOC_VERSION}-linux-x86_64.zip
PROTOC_DL_URL=https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/${PROTOC_ZIP}
UPX_DIR=upx-${UPX_VERSION}-amd64_linux
UPX_TAR=${UPX_DIR}.tar.xz
UPX_DL_URL=https://github.com/upx/upx/releases/download/v${UPX_VERSION}/${UPX_TAR}

printenv

function log() {
    echo "[LOG] $@"
}

function error() {
    echo "[ERROR] $@"
}

if [ -d "${HOME}/tools" ]; then
    log "Tooling directory already exists, skipping setup"
else
    log "Downloading protoc..."

    mkdir "${HOME}/tools"
    wget -O "${HOME}/tools/${PROTOC_ZIP}" "${PROTOC_DL_URL}"

    if [ 0 -ne $# ]; then
        error "Error occurred downloading protoc, exiting..."
        exit -1
    fi

    log "Unzipping protoc"
    pushd "${HOME}/tools"
    unzip "${PROTOC_ZIP}"
    if [ 0 -ne $# ]; then
        error "Error occurred unzipping protoc, exiting..."
        exit -1
    fi
    popd

    log "Installing protoc in PATH"
    ln "${HOME}/tools/bin/protoc" "/usr/bin/protoc"

    log "Installing Go protobuf and gRPC tools"
    go install google.golang.org/protobuf/cmd/protoc-gen-go@${PROTOC_GEN_GO_VERSION}
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@${PROTOC_GEN_GO_GRPC_VERSION}

    if [ "0" == "${UPX_VERSION}" ]; then
        log "User requested no upx installation"
    else
        log "Installing upx"
        wget -O "${HOME}/tools/${UPX_TAR}" "${UPX_DL_URL}"
        if [ 0 -ne $# ]; then
            error "Error occurred downloading upx, exiting..."
            exit -1
        fi

        log "Untarring upx"
        pushd "${HOME}/tools"
        tar -xvf $UPX_TAR
        if [ 0 -ne $# ]; then
            error "Failed to unpack upx, exiting..."
            exit -1
        fi
        popd

        log "Installing upx in PATH"
        log UPX_DIR = $UPX_DIR
        ln "${HOME}/tools/${UPX_DIR}/upx" "/usr/bin/upx"
    fi

    echo;
    echo;
    log Included software
    echo;
    log `go version | cut -d' ' -f 3,4`
    echo;
    echo;
    log Installed software versions
    echo;
    log `protoc --version`
    log `upx --version | head -n 1`
    log `protoc-gen-go --version 2>&1`
    log `protoc-gen-go-grpc --version`
    echo;
fi
