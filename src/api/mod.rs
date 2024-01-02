mod v0;

use anyhow::{Context, Result};
use api_version::{api_version, array_macro};
use axum::{http::StatusCode, response::IntoResponse, routing::get, Router, ServiceExt};
use serde::Deserialize;
use std::{net::IpAddr, time::Duration};
use tokio::{
    net::TcpListener,
    signal::unix::{signal, SignalKind},
    time::sleep,
};
use tower::{Layer, ServiceBuilder};
use tower_http::trace::TraceLayer;

#[derive(Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub struct Config {
    addr: IpAddr,
    port: u16,
    #[serde(with = "humantime_serde")]
    shutdown_timeout: Option<Duration>,
}

pub async fn serve(config: Config) -> Result<()> {
    let Config {
        addr,
        port,
        shutdown_timeout,
    } = config;

    let app = Router::new()
        .nest("/v0", v0::app())
        .layer(ServiceBuilder::new().layer(TraceLayer::new_for_http()));

    let app = api_version!(0..=0).layer(app);

    let listener = TcpListener::bind((addr, port))
        .await
        .context("bind TcpListener")?;
    axum::serve(listener, app.into_make_service())
        .with_graceful_shutdown(shutdown_signal(shutdown_timeout))
        .await
        .context("run server")
}

async fn shutdown_signal(shutdown_timeout: Option<Duration>) {
    signal(SignalKind::terminate())
        .expect("install SIGTERM handler")
        .recv()
        .await;
    if let Some(shutdown_timeout) = shutdown_timeout {
        sleep(shutdown_timeout).await;
    }
}
