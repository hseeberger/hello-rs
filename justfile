set shell := ["bash", "-uc"]

check:
	cargo check --tests

fmt:
	cargo +nightly fmt

fmt_check:
	cargo +nightly fmt --check

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
		.
