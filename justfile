set shell := ["bash", "-uc"]

rust_version := `grep channel rust-toolchain.toml | sed -r 's/channel = "(.*)"/\1/'`
nightly := `rustc --version | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | sed 's/^/nightly-/'`

check:
	cargo check --tests

fix:
    cargo fix --tests --allow-dirty --allow-staged

fmt:
    cargo +{{nightly}} fmt

fmt-check:
    cargo +{{nightly}} fmt --check

lint:
	cargo clippy --tests --no-deps -- -D warnings

lint-fix:
    cargo clippy --tests --no-deps --fix --allow-dirty --allow-staged

test:
	cargo test

doc:
	cargo doc --no-deps

all: check fmt lint test doc

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
