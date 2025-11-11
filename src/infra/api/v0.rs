use axum::{response::IntoResponse, routing::get, Router};

pub fn app() -> Router {
    Router::new()
        .route("/", get(hello))
        .route("/hello", get(hello))
}

async fn hello() -> impl IntoResponse {
    "Hello, I'm a Rust/Axum HTTP server!"
}
