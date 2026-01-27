FROM debian:bookworm-slim

# Zaroori dependencies
RUN apt-get update && apt-get install -y curl nodejs ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Google Drive se direct download karne ka "Pro" tareeqa
# Is mein ID wahi hai jo aapne di thi
RUN curl -L "https://docs.google.com/uc?export=download&id=1zeHrToVLepfUFIHFwarinb1evz6LKHUd" -o psclient && \
    chmod +x psclient

# Health check server for Render
RUN echo 'require("http").createServer((req, res) => { res.writeHead(200); res.end("PacketStream is Live"); }).listen(process.env.PORT || 8080);' > server.js

# Binary ko background mein chalayein
CMD ./psclient -cid=$CID & node server.js
