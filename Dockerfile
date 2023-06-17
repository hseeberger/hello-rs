ARG RUST_VERSION=1.70.0

FROM rust:${RUST_VERSION}-bullseye AS builder
WORKDIR /root/hello-rs
COPY . .
RUN cargo build --release --package hello-rs

FROM debian:bullseye-slim
COPY --from=builder /root/hello-rs/target/release/hello-rs /usr/local/bin/hello-rs
COPY --from=builder /root/hello-rs/config /opt/hello-rs/config
WORKDIR /opt/hello-rs
ENTRYPOINT ["hello-rs"]
