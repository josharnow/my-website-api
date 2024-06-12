# FROM messense/rust-musl-cross:x86_64-musl as chef
# ENV SQLX_OFFLINE=true
# RUN cargo install cargo-chef
# WORKDIR /my-website-api

# FROM chef AS planner
# # Copy source code from previous stage
# COPY . .
# # Generate info for caching dependencies
# RUN cargo chef prepare --recipe-path recipe.json

# FROM chef AS builder
# COPY --from=planner /my-website-api/recipe.json recipe.json
# # Build & cache dependencies
# RUN cargo chef cook --release --target x86_64-unknown-linux-musl --recipe-path recipe.json
# # Copy source code from previous stage
# COPY . .
# # Build application
# RUN cargo build --release --target x86_64-unknown-linux-musl

# # Create a new stage with a minimal image
# FROM scratch
# COPY --from=builder /my-website-api/target/x86_64-unknown-linux-musl/release/my-website-api /my-website-api
# ENTRYPOINT ["/my-website-api"]
# EXPOSE 3000



FROM messense/rust-musl-cross:x86_64-musl AS builder
ENV SQLX_OFFLINE=true
WORKDIR /my-website-api
# Copy the source code
COPY . .
# Build the project
RUN cargo build --release --target x86_64-unknown-linux-musl

# Create a new stage with a minimal image
FROM scratch
COPY --from=builder /my-website-api/target/x86_64-unknown-linux-musl/release/my-website-api /my-website-api
# ENTRYPOINT [ "/target/release/my-website-api" ]
ENTRYPOINT [ "/my-website-api", "--port", "3000" ]
EXPOSE 3000
# NOTE - https://stackoverflow.com/questions/52591197/exposing-configurable-argument-port-at-build


# # NOTE - https://developer.oracle.com/learn/technical-articles/DEVO_Technical-Content/COREE91516B15F61454EA0D028431A811BD9/rust-building-apis-on-oci#copy
# # Using the Rust official image...
# FROM rust

# # Copy the files in your machine to the Docker image...
# COPY ./ ./

# # Build your program for release...
# RUN cargo build --release

# # And run the binary!
# CMD ["./target/release/my-website-api"]