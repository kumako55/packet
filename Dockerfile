# Forcefully pull AMD64
FROM --platform=linux/amd64 packetstream/psclient:latest AS ps-source

FROM --platform=linux/amd64 debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy everything from source
COPY --from=ps-source / /ps-files/

# Server for Render
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is running"); \
}).listen(process.env.PORT || 8080);' > server.js

# Binary dhoondne ka script (Improved)
RUN echo '#!/bin/sh \n\
# Find the correct x64 binary \n\
TARGET_BIN=$(find /ps-files -type f -name "psclient" -executable | grep -v "arm" | head -n 1) \n\
echo "Starting PacketStream with CID: $CID" \n\
# Try with double dash if single fails, and use quotes \n\
$TARGET_BIN -cid="$CID" & \n\
node server.js' > start.sh && chmod +x start.sh

ENTRYPOINT []
CMD ["./start.sh"]
