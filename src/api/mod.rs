mod v0;

use anyhow::{Context, Result};
use axum::{http::StatusCode, response::IntoResponse, routing::get, Router};
use serde::Deserialize;
use std::net::IpAddr;
use tokio::net::TcpListener;
use tower::ServiceBuilder;
use tower_http::trace::TraceLayer;

#[derive(Debug, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub struct Config {
    addr: IpAddr,
    port: u16,
}

pub async fn serve(config: Config) -> Result<()> {
    let Config { addr, port } = config;

    let app = Router::new()
        .route("/", get(ready))
        .nest("/v0", v0::app())
        .layer(ServiceBuilder::new().layer(TraceLayer::new_for_http()));

    let listener = TcpListener::bind((addr, port)).await.context("bind")?;
    axum::serve(listener, app).await.context("run server")
}

async fn ready() -> impl IntoResponse {
    StatusCode::OK
}
