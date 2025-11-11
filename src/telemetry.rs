use logforth::{append::Stdout, filter::env_filter::EnvFilterBuilder, layout::JsonLayout};

/// Initialize logging with [Logforth](https://github.com/fast/logforth).
///
/// Log levels are filterd based on the `RUST_LOG` environment variable and log records are
/// formatted as JSON.
///
/// # Panics
///
/// If logging has already been initialized.
pub fn init_logging() {
    logforth::starter_log::builder()
        .dispatch(|dispatch| {
            dispatch
                .filter(EnvFilterBuilder::from_default_env().build())
                .append(Stdout::default().with_layout(JsonLayout::default()))
        })
        .apply();
}
