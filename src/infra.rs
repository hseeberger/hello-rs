use serde::Deserialize;

pub mod api;

#[derive(Debug, Deserialize)]
pub struct Config {
    pub api: api::Config,
}
