FROM debian:bookworm-slim

# Zaroori tools install karein
RUN apt-get update && apt-get install -y \
    curl \
    nodejs \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Seedha x86_64 (Intel/AMD) wali binary download karein jo Render par chalti hai
RUN curl -L https://packetstream.io/static/bin/psclient-linux-x64 -o /app/psclient && \
    chmod +x /app/psclient

# Dummy server for Render health check
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is running on Render x64"); \
}).listen(process.env.PORT || 8080);' > server.js

# Binary ko force-run karein
CMD ["/bin/sh", "-c", "./psclient -cid ${CID} & node server.js"]
