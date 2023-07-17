ARG RUST_VERSION=1.71.0

FROM rust:${RUST_VERSION}-slim-bullseye AS builder
WORKDIR /app
COPY . .
RUN \
  --mount=type=cache,target=/app/target/ \
  --mount=type=cache,target=/usr/local/cargo/registry/ \
  <<EOF
set -e
cargo build --locked --release --package hello-rs
cp ./target/release/hello-rs /app
EOF

FROM debian:bullseye-slim AS final
RUN adduser \
  --disabled-password \
  --gecos "" \
  --home "/nonexistent" \
  --shell "/sbin/nologin" \
  --no-create-home \
  --uid "10001" \
  appuser
COPY --from=builder /app/hello-rs /usr/local/bin
RUN chown appuser /usr/local/bin/hello-rs
COPY --from=builder /app/config /opt/hello-rs/config
RUN chown -R appuser /opt/hello-rs/config
USER appuser
WORKDIR /opt/hello-rs
ENTRYPOINT ["hello-rs"]
EXPOSE 80/tcp
