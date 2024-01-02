set shell := ["bash", "-uc"]

check:
	cargo check --tests

fmt:
	cargo +nightly fmt

fmt-check:
	cargo +nightly fmt --check

lint:
	cargo clippy --no-deps -- -D warnings

test:
	cargo test

coverage:
	cargo llvm-cov --all-features --workspace --lcov --output-path lcov.info

fix:
	cargo fix --allow-dirty --allow-staged

all: check fmt lint test

run port="8080":
	RUST_LOG=hello_rs=debug,api_version=debug,info \
		APP__API__PORT={{port}} \
		APP__PG_SERVICE_REPOSITORY__PASSWORD=hello-rs \
		cargo run -p hello-rs

docker tag="latest":
	docker build \
		-t hseeberger/hello-rs:{{tag}} \
		-f Dockerfile \
		.
