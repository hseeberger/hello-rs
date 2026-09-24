ARG RUST_VERSION
FROM lukemathwalker/cargo-chef:0.1.78-rust-$RUST_VERSION-trixie AS chef
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
    install -D -m 755 "./target/${PROFILE/dev/debug}/hello-rs" /runtime/usr/local/bin/hello-rs && \
    install -D -m 644 /build/config/default.yaml /runtime/opt/hello-rs/config/default.yaml

FROM gcr.io/distroless/cc-debian13:nonroot@sha256:54df941ed0d06a1bd95ef5e0ce391fd8d9f94b64782dc9a60062727849ee3f97 AS runtime
COPY --from=builder /runtime /
WORKDIR /opt/hello-rs
ENTRYPOINT ["/usr/local/bin/hello-rs"]
