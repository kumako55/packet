# Forcefully pull AMD64 version
FROM --platform=linux/amd64 packetstream/psclient:latest AS ps-source

FROM --platform=linux/amd64 debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy binary from source
COPY --from=ps-source / /ps-files/

# Dummy server for Render
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream Node Active"); \
}).listen(process.env.PORT || 8080);' > server.js

# Start script with DOUBLE DASH flag
RUN echo '#!/bin/sh \n\
TARGET_BIN=$(find /ps-files -type f -name "psclient" -executable | grep -v "arm" | head -n 1) \n\
echo "Executing: $TARGET_BIN --cid $CID" \n\
# Yahan --cid (double dash) use kiya hai \n\
$TARGET_BIN --cid $CID & \n\
node server.js' > start.sh && chmod +x start.sh

ENTRYPOINT []
CMD ["./start.sh"]
