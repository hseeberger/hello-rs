mod v0;

use anyhow::{Context, Result};
use api_version::{ApiVersionLayer, ApiVersions};
use axum::{http::StatusCode, routing::get, Router, ServiceExt};
use serde::Deserialize;
use std::net::IpAddr;
use tokio::{
    net::TcpListener,
    signal::unix::{signal, SignalKind},
};
use tower::Layer;

const API_VERSIONS: ApiVersions<1> = ApiVersions::new([0]);

#[derive(Debug, Deserialize)]
pub struct Config {
    pub addr: IpAddr,
    pub port: u16,
}

pub async fn serve(config: Config) -> Result<()> {
    let Config { addr, port } = config;

    let app = Router::new()
        .route("/ready", get(ready))
        .nest("/api/v0", v0::app());
    let app = ApiVersionLayer::new("/api", API_VERSIONS).layer(app);

    let listener = TcpListener::bind((addr, port))
        .await
        .context("bind TcpListener")?;
    axum::serve(listener, app.into_make_service())
        .with_graceful_shutdown(shutdown_signal())
        .await
        .context("run server")
}

async fn ready() -> StatusCode {
    StatusCode::OK
}

async fn shutdown_signal() {
    signal(SignalKind::terminate())
        .expect("install SIGTERM handler")
        .recv()
        .await;
}
