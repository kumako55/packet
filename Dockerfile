FROM --platform=linux/amd64 packetstream/psclient:latest AS ps-source
FROM --platform=linux/amd64 debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Source se binary copy karein
COPY --from=ps-source / /ps-files/

# Dummy server
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is running"); \
}).listen(process.env.PORT || 8080);' > server.js

# FINAL SCRIPT: No Flags, Just Environment
RUN echo '#!/bin/sh \n\
TARGET_BIN=$(find /ps-files -type f -name "psclient" -executable | grep "amd64" | head -n 1) \n\
BIN_DIR=$(dirname "$TARGET_BIN") \n\
echo "Found Binary at: $TARGET_BIN" \n\
\n\
# CID ko environment mein export karein (Binary yahan se khud uthayegi) \n\
export CID=$CID \n\
\n\
cd "$BIN_DIR" \n\
echo "Starting psclient without flags..." \n\
./psclient & \n\
\n\
cd /app \n\
node server.js' > start.sh && chmod +x start.sh

ENTRYPOINT []
CMD ["./start.sh"]
