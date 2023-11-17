ARG RUST_VERSION=1.74.0

FROM rust:${RUST_VERSION}-slim-bookworm AS builder
WORKDIR /app
COPY . .
RUN \
  --mount=type=cache,target=/app/target/ \
  --mount=type=cache,target=/usr/local/cargo/registry/ \
  cargo build --locked --release && \
  cp ./target/release/hello-rs /app

FROM debian:bookworm-slim AS final
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
ENV RUST_LOG="hello_rs=debug,tower_http=debug,info"
WORKDIR /opt/hello-rs
ENTRYPOINT ["hello-rs"]
EXPOSE 8080/tcp
