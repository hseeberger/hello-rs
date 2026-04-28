use axum::{Router, response::IntoResponse, routing::get};

pub fn app() -> Router {
    Router::new()
        .route("/", get(hello))
        .route("/hello", get(hello))
}

async fn hello() -> impl IntoResponse {
    "Hello, I'm a Rust/Axum HTTP server!"
}
