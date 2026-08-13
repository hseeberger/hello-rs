mod infra;

use anyhow::{Context, Result};
use configured::{Case, Configured};
use serde::Deserialize;
use std::panic;
use tracing::{error, info};
use tracing_subscriber::{EnvFilter, layer::SubscriberExt, util::SubscriberInitExt};

#[tokio::main]
async fn main() {
    init_tracing();

    panic::set_hook(Box::new(|panic| error!(%panic, "process panicked")));

    if let Err(error) = run().await {
        let backtrace = error.backtrace();
        let error = format!("{error:#}");
        error!(error, %backtrace, "process exited with ERROR")
    }
}

#[derive(Debug, Deserialize)]
struct Config {
    pub infra: infra::Config,
}

fn init_tracing() {
    tracing_subscriber::registry()
        .with(EnvFilter::from_default_env())
        .with(tracing_subscriber::fmt::layer().json().flatten_event(true))
        .init();
}

async fn run() -> Result<()> {
    let config = Config::load(Case::Snake).context("load configuration")?;
    info!(?config, "starting");

    infra::api::serve(config.infra.api).await
}
