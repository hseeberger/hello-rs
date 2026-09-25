# Changelog

## [0.8.0](https://github.com/hseeberger/hello-rs/compare/v0.7.1...v0.8.0) - 2026-09-25

### Bug Fixes

- Return ExitCode from main ([#241](https://github.com/hseeberger/hello-rs/pull/241))

### Refactor

- Switch from log/logforth to tracing ([#226](https://github.com/hseeberger/hello-rs/pull/226))
- *(config)* Replace figment with configured ([#199](https://github.com/hseeberger/hello-rs/pull/199))

### Miscellaneous Tasks

- Standardize project scaffolding and package metadata ([#192](https://github.com/hseeberger/hello-rs/pull/192))
- *(build)* Apply common hseeberger project shape ([#175](https://github.com/hseeberger/hello-rs/pull/175))

### Dependencies

- Bump Rust to 1.98.1 ([#236](https://github.com/hseeberger/hello-rs/pull/236))
- Bump configured in the cargo-patch group ([#234](https://github.com/hseeberger/hello-rs/pull/234))
- Bump Rust to 1.98.0 ([#231](https://github.com/hseeberger/hello-rs/pull/231))
- Update h2 to 0.4.17 ([#230](https://github.com/hseeberger/hello-rs/pull/230))
- Bump the cargo-patch group across 1 directory with 2 updates ([#227](https://github.com/hseeberger/hello-rs/pull/227))
- Bump the cargo-patch group with 3 updates ([#221](https://github.com/hseeberger/hello-rs/pull/221))
- Bump tokio in the cargo-minor group across 1 directory ([#219](https://github.com/hseeberger/hello-rs/pull/219))
- Bump the cargo-patches group across 1 directory with 2 updates ([#217](https://github.com/hseeberger/hello-rs/pull/217))
- Bump Rust to 1.97.0 ([#206](https://github.com/hseeberger/hello-rs/pull/206))
- Bump configured ([#211](https://github.com/hseeberger/hello-rs/pull/211))
- Bump api-version ([#200](https://github.com/hseeberger/hello-rs/pull/200))
- Bump anyhow in the cargo-patches group across 1 directory ([#195](https://github.com/hseeberger/hello-rs/pull/195))
- Bump the all group across 1 directory with 3 updates ([#186](https://github.com/hseeberger/hello-rs/pull/186))
- Bump Rust to 1.96.0 ([#182](https://github.com/hseeberger/hello-rs/pull/182))
- Bump tokio in the all group across 1 directory ([#179](https://github.com/hseeberger/hello-rs/pull/179))
- Bump the all group across 1 directory with 2 updates ([#173](https://github.com/hseeberger/hello-rs/pull/173))
- Update Rust to 1.94.1 ([#168](https://github.com/hseeberger/hello-rs/pull/168))
- Bump Rust to 1.94.0
- Bump api-version from 0.3.4 to 0.3.5 ([#164](https://github.com/hseeberger/hello-rs/pull/164))
- Bump anyhow from 1.0.101 to 1.0.102 ([#138](https://github.com/hseeberger/hello-rs/pull/138))
- Bump tokio from 1.49.0 to 1.50.0 ([#145](https://github.com/hseeberger/hello-rs/pull/145))
- Bump bytes from 1.11.0 to 1.11.1 ([#123](https://github.com/hseeberger/hello-rs/pull/123))
- Bump anyhow from 1.0.100 to 1.0.101 ([#126](https://github.com/hseeberger/hello-rs/pull/126))
- Bump tower from 0.5.2 to 0.5.3 ([#107](https://github.com/hseeberger/hello-rs/pull/107))
- Bump api-version from 0.3.3 to 0.3.4 ([#105](https://github.com/hseeberger/hello-rs/pull/105))
- Bump tokio from 1.48.0 to 1.49.0 ([#102](https://github.com/hseeberger/hello-rs/pull/102))
- Bump axum from 0.8.7 to 0.8.8 ([#93](https://github.com/hseeberger/hello-rs/pull/93))
- Bump Rust to 1.92.0 ([#87](https://github.com/hseeberger/hello-rs/pull/87))
- Bump debian from `18764e9` to `e711a7b` ([#83](https://github.com/hseeberger/hello-rs/pull/83))
- Bump log from 0.4.28 to 0.4.29 ([#79](https://github.com/hseeberger/hello-rs/pull/79))

## [0.7.1] - 2025-11-26

### ⚙️ Miscellaneous Tasks

- *(deps)* Bump taiki-e/install-action from 2.62.50 to 2.62.51 (#59)
- *(deps)* Bump axum from 0.8.6 to 0.8.7 (#60)
- Pin GH actions (#61)
- *(deps)* Bump debian from `a347fd7` to `c0accef` (#62)
- *(deps)* Bump taiki-e/install-action from 2.62.53 to 2.62.54 (#64)
- *(deps)* Bump debian from `c0accef` to `18764e9` (#63)
- *(deps)* Bump actions/checkout from 5.0.1 to 6.0.0 (#65)
- *(deps)* Bump dtolnay/rust-toolchain (#66)
- *(deps)* Bump taiki-e/install-action from 2.62.54 to 2.62.57 (#67)
- *(deps)* Bump api-version to 0.3.3 (#69)
- *(docker build)* Cleanup build and push job (#70)
- Add trigger on push to main or tag (#71)
## [0.7.0] - 2025-11-12

### 🚀 Features

- Rewrite
