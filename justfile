set shell := ["bash", "-uc"]

check:
	cargo check

fmt toolchain="+nightly":
	cargo {{toolchain}} fmt

fmt-check toolchain="+nightly":
	cargo {{toolchain}} fmt --check

lint:
	cargo clippy --no-deps -- -D warnings

test:
	cargo test

fix:
	cargo fix --allow-dirty --allow-staged

all: check fmt lint test

run port="8080":
	RUST_LOG=hello_rs=debug,api_version=debug,tower_http=debug,info \
		APP__API__PORT={{port}} \
		APP__PG_SERVICE_REPOSITORY__PASSWORD=hello-rs \
		cargo run -p hello-rs

docker tag="latest":
	docker build \
		-t hseeberger/hello-rs:{{tag}} \
		-f Dockerfile \
		.
