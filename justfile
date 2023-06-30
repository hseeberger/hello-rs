set shell := ["bash", "-uc"]

rust_version := `grep 'rust-version' Cargo.toml | grep -Eo '\d+\.\d+\.\d+'`

check:
	cargo check --tests

fmt:
	cargo +nightly fmt

lint:
	cargo clippy --no-deps -- -D warnings

test:
	cargo test

all: fmt check lint test

run:
	RUST_LOG=hello_rs=debug,info \
		APP__API__PORT=8080 \
		cargo run -p hello-rs \
		| jq

docker:
	docker build \
		-t hseeberger/hello-rs \
		--build-arg RUST_VERSION={{rust_version}} \
		.
