mod infra;

use anyhow::Context;
use configured::{Configured, LoadOptions};
use serde::Deserialize;
use serde_json::json;
use std::{panic, process::ExitCode};
use tracing::{error, info};
use tracing_subscriber::{EnvFilter, layer::SubscriberExt, util::SubscriberInitExt};

#[tokio::main]
async fn main() -> ExitCode {
    let Ok(config) = Config::load(LoadOptions::default())
        .context("load configuration")
        .inspect_err(log_error)
    else {
        return ExitCode::FAILURE;
    };

    init_tracing();

    panic::set_hook(Box::new(|panic| error!(%panic, "process panicked")));

    if let Err(error) = run(config).await {
        let backtrace = error.backtrace();
        let error = format!("{error:#}");
        error!(error, %backtrace, "process exited with ERROR");
        return ExitCode::FAILURE;
    }

    ExitCode::SUCCESS
}

#[derive(Debug, Deserialize)]
struct Config {
    pub infra: infra::Config,
}

fn log_error(error: &anyhow::Error) {
    let error = json!({
        "level": "ERROR",
        "message": "process exited with ERROR",
        "error": format!("{error:#}"),
    });
    println!("{error}");
}

fn init_tracing() {
    tracing_subscriber::registry()
        .with(EnvFilter::from_default_env())
        .with(tracing_subscriber::fmt::layer().json().flatten_event(true))
        .init();
}

async fn run(config: Config) -> anyhow::Result<()> {
    info!(?config, "starting");

    infra::api::serve(config.infra.api).await
}
