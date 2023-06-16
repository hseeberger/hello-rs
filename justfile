set shell := ["bash", "-uc"]

rust_version := `grep channel rust-toolchain.toml | sed -r 's/channel = "(.*)"/\1/'`
nightly := "nightly-2025-10-29"

check:
	cargo check --tests

fix:
    cargo fix --allow-dirty --allow-staged --tests

fmt:
    cargo +{{nightly}} fmt

fmt-check:
    cargo +{{nightly}} fmt --check

lint:
	cargo clippy --no-deps --tests -- -D warnings

lint-fix:
    cargo clippy --no-deps --tests --fix --allow-dirty --allow-staged

test:
	cargo test

all: check fmt lint test

run port="8080":
	RUST_LOG=hello_rs=debug,api_version=debug,warn \
		APP__INFRA__API__PORT={{port}} \
		cargo run -p hello-rs

build-docker-image profile="dev":
    tag=$(git rev-parse --short=8 HEAD) && \
    docker build \
        --build-arg "RUST_VERSION={{rust_version}}" \
        --build-arg "PROFILE={{profile}}" \
        -t hseeberger/hello-rs:${tag} \
        -t hseeberger/hello-rs:latest \
        -f Dockerfile \
        .
