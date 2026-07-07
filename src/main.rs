mod infra;

use anyhow::{Context, Result};
use configured::{Case, Configured};
use log::{error, info};
use logforth::{append::Stdout, filter::rustlog::RustLogFilterBuilder, layout::JsonLayout};
use serde::Deserialize;
use std::panic;

#[tokio::main]
async fn main() {
    init_logging();

    // Replace the default panic hook with one that uses structured logging at ERROR level.
    panic::set_hook(Box::new(|panic| error!(panic:%; "process panicked")));

    // Run and log any error.
    if let Err(error) = run().await {
        let backtrace = error.backtrace();
        let error = format!("{error:#}");
        error!(error, backtrace:%; "process exited with ERROR")
    }
}

#[derive(Debug, Deserialize)]
struct Config {
    pub infra: infra::Config,
}

async fn run() -> Result<()> {
    let config = Config::load(Case::Snake).context("load configuration")?;
    info!(config:?; "starting");

    infra::api::serve(config.infra.api).await
}

pub fn init_logging() {
    logforth::starter_log::builder()
        .dispatch(|dispatch| {
            dispatch
                .filter(RustLogFilterBuilder::from_default_env().build())
                .append(Stdout::default().with_layout(JsonLayout::default()))
        })
        .apply();
}
