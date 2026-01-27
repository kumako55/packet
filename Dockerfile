FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y curl nodejs ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Google Drive binary download (with bypass)
RUN curl -L "https://docs.google.com/uc?export=download&confirm=$(curl -sL 'https://docs.google.com/uc?export=download&id=1zeHrToVLepfUFIHFwarinb1evz6LKHUd' | grep -o 'confirm=[^&]*' | sed 's/confirm=//')&id=1zeHrToVLepfUFIHFwarinb1evz6LKHUd" -o psclient && \
    chmod +x psclient

# Health Check Server
RUN echo 'require("http").createServer((req, res) => { res.writeHead(200); res.end("Checking Logs..."); }).listen(process.env.PORT || 8080);' > server.js

# Binary ko Help mode mein chalayein aur phir Background mein
# Is se humein logs mein asli flags nazar aa jayenge
CMD ./psclient --help; export CID=$CID && ./psclient & node server.js
