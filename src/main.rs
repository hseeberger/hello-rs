mod config;
mod infra;
mod telemetry;

use anyhow::{Context, Result};
use log::{error, info};
use serde::Deserialize;
use std::panic;

use crate::config::ConfigExt;

#[tokio::main]
async fn main() {
    // Initialize logging.
    telemetry::init_logging();

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
    let config = Config::load().context("load configuration")?;
    info!(config:?; "starting");
    infra::api::serve(config.infra.api).await
}
