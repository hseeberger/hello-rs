set shell := ["bash", "-uc"]

rust_version := `grep channel rust-toolchain.toml | sed -r 's/channel = "(.*)"/\1/'`
nightly := `rustc --version | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | sed 's/^/nightly-/'`

check:
    cargo check --tests

fix:
    cargo fix --tests --allow-dirty --allow-staged

fmt:
    cargo +{{ nightly }} fmt
    RUST_LOG=error taplo fmt

fmt-check:
    cargo +{{ nightly }} fmt --check

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
    	CFG__INFRA__API__PORT={{ port }} \
    	cargo run -p hello-rs | tee ./target/hello-rs.log

build-docker-image profile="dev":
    tag=$(git rev-parse --short=8 HEAD) && \
    docker build \
        --build-arg "RUST_VERSION={{ rust_version }}" \
        --build-arg "PROFILE={{ profile }}" \
        -t hseeberger/hello-rs:${tag} \
        -t hseeberger/hello-rs:latest \
        -f Dockerfile \
        .

release-pr:
    release-plz release-pr --git-token "$(gh auth token)"

release:
    #!/usr/bin/env bash
    set -euo pipefail
    git fetch --quiet --tags origin main
    if [[ $(git branch --show-current) != main || -n $(git status --porcelain) || $(git rev-parse HEAD) != $(git rev-parse origin/main) ]]; then
        echo "error: must run on a clean main that is up to date with origin/main" >&2
        exit 1
    fi
    version=$(grep '^version' Cargo.toml | sed -E 's/version *= *"(.*)"/\1/')
    commit=$(git log -1 --format=%H -G '^version' -- Cargo.toml)
    git tag -a "v$version" -m "chore: release v$version" "$commit"
    git push origin "v$version"
    awk -v heading="## [$version]" 'index($0, heading) == 1 { found = 1; next } /^## \[/ { found = 0 } found' CHANGELOG.md |
        gh release create "v$version" --title "$version" --notes-file - --verify-tag
