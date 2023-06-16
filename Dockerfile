ARG RUST_VERSION
FROM lukemathwalker/cargo-chef:0.1.73-rust-$RUST_VERSION-trixie AS chef
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

FROM debian:trixie-slim@sha256:a347fd7510ee31a84387619a492ad6c8eb0af2f2682b916ff3e643eb076f925a AS runtime
RUN useradd -u 10001 -d /nonexistent -s /usr/sbin/nologin -M -c "" appuser && \
    passwd -l appuser && \
    mkdir /var/run/hello-rs && \
    chown appuser:appuser /var/run/hello-rs
COPY --from=builder --chown=appuser:appuser /runtime /
USER appuser
WORKDIR /opt/hello-rs
ENTRYPOINT ["entrypoint.sh"]
