FROM ubuntu:20.04 as base

# The Rust toolchain to use when building our image.  Set by `hooks/build`.
ARG TOOLCHAIN=stable

# The OpenSSL version to use. Here is the place to check for new releases:
#
# - https://www.openssl.org/source/
#
# ALSO UPDATE hooks/build!
ARG OPENSSL_VERSION=1.1.1i

# Versions for other dependencies. Here are the places to check for new
# releases:
#
# - https://github.com/rust-lang/mdBook/releases
# - https://github.com/EmbarkStudios/cargo-about/releases
# - https://github.com/EmbarkStudios/cargo-deny/releases
# - http://zlib.net/
# - https://ftp.postgresql.org/pub/source/
#
# We're stuck on PostgreSQL 11 until we figure out
# https://github.com/emk/rust-musl-builder/issues.
ARG MDBOOK_VERSION=0.4.6
ARG CARGO_ABOUT_VERSION=0.2.3
ARG CARGO_DENY_VERSION=0.8.5
ARG ZLIB_VERSION=1.2.11
ARG POSTGRESQL_VERSION=11.11

# Make sure we have basic dev tools for building C libraries.  Our goal here is
# to support the musl-libc builds and Cargo builds needed for a large selection
# of the most popular crates.
#
# We also set up a `rust` user by default. This user has sudo privileges if you
# need to install any more software.
#
# `mdbook` is the standard Rust tool for making searchable HTML manuals.
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
     # libjasper-dev libpng12-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
    apt-get install -yq \
        build-essential \
        ninja-build \
        wget \
        curl \
        file \
        git \
        graphviz \
        musl-dev \
        musl-tools \
        libjpeg8-dev libtiff5-dev \
        libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev \
        libxine2-dev libv4l-dev \
        libgtk2.0-dev libtbb-dev qt5-default \
        libatlas-base-dev \
        libfaac-dev libmp3lame-dev libtheora-dev \
        libvorbis-dev libxvidcore-dev \
        libopencore-amrnb-dev libopencore-amrwb-dev \
        libavresample-dev \
        x264 v4l-utils \
        llvm-10 clang-10 libclang-10-dev \
        libpq-dev \
        libsqlite-dev \
        libssl-dev \
        libopencv-dev \
        linux-libc-dev \
        pkgconf \
        xutils-dev \
        python3 gfortran \
        yasm \
        && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    useradd rust --user-group --create-home --shell /bin/bash --groups sudo && \
    curl -fLO https://github.com/rust-lang-nursery/mdBook/releases/download/v$MDBOOK_VERSION/mdbook-v$MDBOOK_VERSION-x86_64-unknown-linux-gnu.tar.gz && \
    tar xf mdbook-v$MDBOOK_VERSION-x86_64-unknown-linux-gnu.tar.gz && \
    mv mdbook /usr/local/bin/ && \
    rm -f mdbook-v$MDBOOK_VERSION-x86_64-unknown-linux-gnu.tar.gz && \
    curl -fLO https://github.com/EmbarkStudios/cargo-about/releases/download/$CARGO_ABOUT_VERSION/cargo-about-$CARGO_ABOUT_VERSION-x86_64-unknown-linux-musl.tar.gz && \
    tar xf cargo-about-$CARGO_ABOUT_VERSION-x86_64-unknown-linux-musl.tar.gz && \
    mv cargo-about-$CARGO_ABOUT_VERSION-x86_64-unknown-linux-musl/cargo-about /usr/local/bin/ && \
    rm -rf cargo-about-$CARGO_ABOUT_VERSION-x86_64-unknown-linux-musl.tar.gz cargo-about-$CARGO_ABOUT_VERSION-x86_64-unknown-linux-musl && \
    curl -fLO https://github.com/EmbarkStudios/cargo-deny/releases/download/$CARGO_DENY_VERSION/cargo-deny-$CARGO_DENY_VERSION-x86_64-unknown-linux-musl.tar.gz && \
    tar xf cargo-deny-$CARGO_DENY_VERSION-x86_64-unknown-linux-musl.tar.gz && \
    mv cargo-deny-$CARGO_DENY_VERSION-x86_64-unknown-linux-musl/cargo-deny /usr/local/bin/ && \
    rm -rf cargo-deny-$CARGO_DENY_VERSION-x86_64-unknown-linux-musl cargo-deny-$CARGO_DENY_VERSION-x86_64-unknown-linux-musl.tar.gz

# Static linking for C++ code
# RUN ln -s "/usr/bin/g++" "/usr/bin/musl-g++"

RUN mkdir ~/temp && cd ~/temp && \
    wget --no-check-certificate https://cmake.org/files/v3.19/cmake-3.19.8.tar.gz && \
    tar -xzvf cmake-3.19.8.tar.gz && \
    cd cmake-3.19.8/ && \
    ./bootstrap && \
    make -j1 && \
    make install

# RUN mkdir ~/temp && cd ~/temp && \
#     wget --no-check-certificate https://cmake.org/files/v3.20/cmake-3.20.1-linux-x86_64.tar.gz && \
#     tar -xzvf cmake-3.20.1-linux-x86_64.tar.gz && \
#     cd cmake-3.20.1-linux-x86_64/ && \
#     make install, how 

# (Please feel free to submit pull requests for musl-libc builds of other C
# libraries needed by the most popular and common Rust crates, to avoid
# everybody needing to build them manually.)

# Install a `git credentials` helper for using GH_USER and GH_TOKEN to access
# private repositories if desired. We make sure this is configured for root,
# here, and for the `rust` user below.
# ADD git-credential-ghtoken /usr/local/bin/ghtoken
# RUN git config --global credential.https://github.com.helper ghtoken

# Set up our path with all our binary directories, including those for the
# musl-gcc toolchain and for our Rust toolchain.
#
# We use the instructions at https://github.com/rust-lang/rustup/issues/2383
# to install the rustup toolchain as root.
ENV RUSTUP_HOME=/opt/rust/rustup \
    PATH=/home/rust/.cargo/bin:/opt/rust/cargo/bin:/usr/local/musl/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV CARGO_HOME=/opt/rust/cargo

# Install our Rust toolchain and the `musl` target.  We patch the
# command-line we pass to the installer so that it won't attempt to
# interact with the user or fool around with TTYs.  We also set the default
# `--target` to musl so that our users don't need to keep overriding it
# manually.
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- -y --default-toolchain $TOOLCHAIN && \
    rustup component add rustfmt rustfmt rustc-dev && \
    rustup component add clippy && \
    rustup target add x86_64-unknown-linux-musl && \
    rustup target add armv7-unknown-linux-musleabihf

RUN rustup update


# Cross-compile the app for musl to create a statically-linked binary for alpine.
FROM --platform=$BUILDPLATFORM base AS builder
# FROM --platform=$BUILDPLATFORM ekidd/rust-musl-builder as builder
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" 
# > /log
RUN case "$TARGETPLATFORM" in \
      "linux/arm/v7") echo armv7-unknown-linux-musleabihf > /tmp/rust_target.txt ;; \
      "linux/arm/v6") echo arm-unknown-linux-musleabihf > /tmp/rust_target.txt ;; \
      "linux/amd64") echo amd64-unknown-linux-musleabihf > /tmp/rust_target.txt ;; \
      *) exit 1 ;; \
    esac

# RUN apk add build-base 

WORKDIR /home/rust
# We need to add the source code to the image because `rust-musl-builder`
# assumes a UID of 1000, but TravisCI has switched to 2000.
COPY --chown=rust:rust . /home/rust

RUN git clone https://github.com/microsoft/vcpkg && ./vcpkg/bootstrap-vcpkg.sh

RUN cargo test

# TODO https://docs.docker.com/buildx/working-with-buildx/#build-multi-platform-images
# TODO make own thepia/rustup-builder

RUN cargo build --release --target $(cat /tmp/rust_target.txt)
# Move the binary to a location free of the target since that is not available in the next stage.
# RUN cp target/$(cat /rust_target.txt)/release/subcognition .


FROM alpine:3.12
ENV \
    # Show full backtraces for crashes.
    RUST_BACKTRACE=full
RUN apk add --no-cache \
      tini \
    && rm -rf /var/cache/* \
    && mkdir /var/cache/apk

# Project directory is /root
WORKDIR /usr
COPY --from=builder /home/rust/subcognition ./bin

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/bin/subcognition", "--http-port", "80", "/config/config.toml"]

HEALTHCHECK --interval=1m --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1