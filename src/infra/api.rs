mod v0;

use anyhow::{Context, Result};
use api_version::{ApiVersionFilter, ApiVersionLayer, ApiVersions};
use axum::{
    http::{StatusCode, Uri},
    routing::get,
    Router, ServiceExt,
};
use serde::Deserialize;
use std::{convert::Infallible, net::IpAddr};
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
        .nest("/v0", v0::app());
    let app = ApiVersionLayer::new(API_VERSIONS, ReadyApiVersionFilterFilter).layer(app);

    let listener = TcpListener::bind((addr, port))
        .await
        .context("bind TcpListener")?;
    axum::serve(listener, app.into_make_service())
        .with_graceful_shutdown(shutdown_signal())
        .await
        .context("run server")
}

#[derive(Clone)]
struct ReadyApiVersionFilterFilter;

impl ApiVersionFilter for ReadyApiVersionFilterFilter {
    type Error = Infallible;

    async fn should_rewrite(&self, uri: &Uri) -> Result<bool, Self::Error> {
        Ok(uri.path() != "/ready")
    }
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
