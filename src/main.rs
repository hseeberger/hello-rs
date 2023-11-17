mod api;

use anyhow::{Context, Result};
use configured::Configured;
use serde::Deserialize;
use serde_json::json;
use std::panic;
use time::{format_description::well_known::Rfc3339, OffsetDateTime};
use tracing::{error, info};
use tracing_subscriber::{fmt, layer::SubscriberExt, util::SubscriberInitExt, EnvFilter};

#[tokio::main]
async fn main() -> Result<()> {
    // If tracing initialization fails, nevertheless emit a structured log event.
    init_tracing().inspect_err(|error| {
        let now = OffsetDateTime::now_utc().format(&Rfc3339).unwrap();
        let error = serde_json::to_string(&json!({
            "timestamp": now,
            "level": "ERROR",
            "message": "process exited with ERROR",
            "error": format!("{error:#}")
        }));
        // Not using `eprintln!`, because `tracing_subscriber::fmt` uses stdout by default.
        println!("{}", error.unwrap());
    })?;

    // Replace the default panic hook with one that uses structured logging at ERROR level.
    panic::set_hook(Box::new(|panic| error!(%panic, "process panicked")));

    // Run and log any error.
    run().await.inspect_err(|error| {
        error!(
            error = format!("{error:#}"),
            backtrace = %error.backtrace(),
            "process exited with ERROR"
        );
    })
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
struct Config {
    api: api::Config,
}

async fn run() -> Result<()> {
    let config = Config::load().context("load configuration")?;

    info!(?config, "starting");

    api::serve(config.api).await
}

fn init_tracing() -> Result<()> {
    tracing_subscriber::registry()
        .with(EnvFilter::from_default_env())
        .with(fmt::layer().json().flatten_event(true))
        .try_init()
        .context("initialize tracing subscriber")
}
