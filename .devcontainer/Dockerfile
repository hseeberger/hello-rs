# 1.95.0-trixie
FROM rust@sha256:0ccf3b8640fa428d4ff623644960010144fbadd3523d45e66374de1ca2e7abf6
RUN rustup set profile default && rustup component add rustfmt clippy rust-docs

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        fish \
        fzf \
        starship \
        direnv \
        just \
        ripgrep \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
RUN cargo binstall --no-confirm cargo-shear cargo-edit

RUN useradd -m -u 1000 devuser
USER devuser
RUN mkdir -p /home/devuser/cache

WORKDIR /workspace
CMD ["fish"]
