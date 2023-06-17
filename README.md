# hello-rs

Simple dockerized Rust/Axum based HTTP server for demo purposes.

## Run locally

From the workspace root directory:

```
RUST_LOG=hello_rs=debug,info \
  cargo run -p hello-rs \
  | jq
```

## Configuration

See `config/default.yaml` or override settings via env vars. See
[configured](https://github.com/hseeberger/configured) for details.

Example:

```
RUST_LOG=hello_rs=debug,info \
  APP__API__PORT=8080 \
  cargo run -p hello-rs \
  | jq
```

## Docker

To build the Docker image, from the workspace root directory:

```
docker build \
  -t hseeberger/hello-rs \
  --build-arg RUST_VERSION=1.70.0 \
  .
```

To run the Docker image:

```
docker run \
  -p 8080:80 \
  -e RUST_LOG=info,hello_rs=debug \
  hseeberger/hello-rs:latest
```

## License ##

This code is open source software licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).
