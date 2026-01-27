FROM debian:bookworm-slim

# Step 1: Zaroori cheezain install karein
RUN apt-get update && apt-get install -y curl nodejs ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Step 2: Seedha x64 binary download karein (Jo Render par chalti hai)
# Hum "User-Agent" use kar rahe hain taake PacketStream download block na kare
RUN curl -L -A "Mozilla/5.0" https://packetstream.io/static/bin/psclient-linux-x64 -o /app/psclient && \
    chmod +x /app/psclient

# Step 3: Dummy server for Render health check
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is Live"); \
}).listen(process.env.PORT || 8080);' > server.js

# Step 4: Binary aur Server dono ko chalao (Bina kisi ENTRYPOINT conflict ke)
CMD ./psclient -cid $CID & node server.js
