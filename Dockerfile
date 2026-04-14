ARG RUST_VERSION
FROM lukemathwalker/cargo-chef:0.1.77-rust-$RUST_VERSION-trixie AS chef
WORKDIR /build

FROM chef AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
SHELL ["/bin/bash", "-c"]
ARG PROFILE=release
COPY --from=planner /build/recipe.json recipe.json
RUN cargo chef cook --profile $PROFILE --recipe-path recipe.json
COPY . .
RUN cargo build --locked --profile $PROFILE && \
    mkdir -p /runtime/usr/local/bin && \
    mv "./target/${PROFILE/dev/debug}/hello-rs" /runtime/usr/local/bin && \
    mv /build/bin/entrypoint.sh /runtime/usr/local/bin && \
    mkdir -p /runtime/opt/hello-rs && \
    mv /build/config.yaml /runtime/opt/hello-rs

FROM dhi.io/debian-base:trixie@sha256:9bbe6d9dc0d7c341be923f144089a04a91985fe4b7509beacb6154c562f6b475 AS runtime
COPY --from=builder --chown=10001:10001 /runtime /
RUN mkdir -p /var/run/hello-rs && \
    chown 10001:10001 /var/run/hello-rs
USER 10001:10001
WORKDIR /opt/hello-rs
ENTRYPOINT ["entrypoint.sh"]
