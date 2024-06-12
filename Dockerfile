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
ENTRYPOINT [ "/my-website-api" ]
EXPOSE 3000