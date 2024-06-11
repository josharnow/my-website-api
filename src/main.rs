// NOTE - https://medium.com/@lindblomdev/beginning-rust-by-exploring-a-very-basic-axum-web-api-in-detail-1f4c87e422e0
use axum::{
    routing::get,
    Json, Router,
};
use std::net::SocketAddr;

#[tokio::main]
async fn main() {
    let app: Router = Router::new()
        .route("/", get(handler));

    let tcp_listener = tokio::net::TcpListener::bind("0.0.0.0:3030").await.unwrap();


    let addr = SocketAddr::from(([127, 0, 0, 1], 3030));
    println!("Server started, listening on {addr}");
    // NOTE - https://www.reddit.com/r/rust/comments/1birpyo/comment/kvmb18x/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
    // axum::Server::bind(&addr)
    //     .serve(app.into_make_service())
    //     .await
    //     .expect("Failed to start server");
    axum::serve::serve(tcp_listener, app.into_make_service())
        .await
        .expect("Failed to start server");
}

#[derive(serde::Serialize)]
struct Message {
    message: String,
}

async fn handler() -> Json<Message> {
    Json(Message {
        message: String::from("Hello, World!"),
    })
}