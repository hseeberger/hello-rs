set shell := ["bash", "-uc"]

check:
	@echo "RUSTUP_TOOLCHAIN is ${RUSTUP_TOOLCHAIN:-not set}"
	cargo check --tests

fmt:
	@echo "RUSTUP_TOOLCHAIN is ${RUSTUP_TOOLCHAIN:-not set}"
	cargo fmt

fmt-check:
	@echo "RUSTUP_TOOLCHAIN is ${RUSTUP_TOOLCHAIN:-not set}"
	cargo fmt --check

lint:
	@echo "RUSTUP_TOOLCHAIN is ${RUSTUP_TOOLCHAIN:-not set}"
	cargo clippy --no-deps -- -D warnings

test:
	@echo "RUSTUP_TOOLCHAIN is ${RUSTUP_TOOLCHAIN:-not set}"
	cargo test

fix:
	@echo "RUSTUP_TOOLCHAIN is ${RUSTUP_TOOLCHAIN:-not set}"
	cargo fix --allow-dirty --allow-staged

all: check fmt lint test

run port="8080":
	RUST_LOG=hello_rs=debug,info \
		APP__API__PORT={{port}} \
		cargo run -p hello-rs \
		| jq

docker tag="latest":
	docker build \
		-t hseeberger/hello-rs:{{tag}} \
		.
