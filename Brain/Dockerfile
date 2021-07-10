# Cross-compile the app for musl to create a statically-linked binary for alpine.
# FROM --platform=$BUILDPLATFORM rust:1.52.1 
FROM messense/rust-musl-cross:armv7-musleabihf AS rust
ARG TARGETPLATFORM
RUN case "$TARGETPLATFORM" in \
      "linux/arm/v7") echo armv7-unknown-linux-musleabihf > /rust_target.txt ;; \
      "linux/arm/v6") echo arm-unknown-linux-musleabihf > /rust_target.txt ;; \
      *) exit 1 ;; \
    esac
RUN rustup target add $(cat /rust_target.txt)
RUN apt-get update && apt-get -y install binutils-arm-linux-gnueabihf

# Project directory is /opt/talki
WORKDIR /opt/talki
# COPY awareness/subcognition/.cargo ./.cargo
# COPY awareness/subcognition/Cargo.toml awareness/subcognition/Cargo.lock awareness/subcognition/.rustfmt.toml ./
# COPY awareness/subcognition/src ./src

# RUN cargo build --release --target $(cat /rust_target.txt)
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

# Project directory is /opt/talki
WORKDIR /opt/talki
COPY --from=rust /opt/talki/subcognition ./

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/talki/subcognition", "--http-port", "80", "/config/config.toml"]

EXPOSE 8080:80
HEALTHCHECK --interval=1m --timeout=3s \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1