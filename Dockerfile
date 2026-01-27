# Step 1: Forcefully pull only the AMD64 (x64) version of PacketStream
FROM --platform=linux/amd64 packetstream/psclient:latest AS ps-source

# Step 2: Use a clean Debian base
FROM --platform=linux/amd64 debian:bookworm-slim

# Install Node.js for Render health check
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the binary from the AMD64 source image
# Hum binary dhoondne ke liye wahi search logic use karenge jo pehle kaam kar gaya tha
COPY --from=ps-source / /ps-files/

# Dummy server for Render
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream x64 is Active"); \
}).listen(process.env.PORT || 8080);' > server.js

# Final Start Script
RUN echo '#!/bin/sh \n\
TARGET_BIN=$(find /ps-files -type f -name "psclient" -executable | grep -v "arm" | head -n 1) \n\
echo "Executing: $TARGET_BIN" \n\
$TARGET_BIN -cid $CID & \n\
node server.js' > start.sh && chmod +x start.sh

ENTRYPOINT []
CMD ["./start.sh"]
