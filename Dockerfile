FROM --platform=linux/amd64 packetstream/psclient:latest AS ps-source

FROM --platform=linux/amd64 debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Poori source image ko copy karein
COPY --from=ps-source / /ps-files/

# Dummy server
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream Node is Live"); \
}).listen(process.env.PORT || 8080);' > server.js

# Script jo sahi binary dhoond kar usi ke folder se chalayega
RUN echo '#!/bin/sh \n\
# 1. Sirf amd64 wali binary dhoondo \n\
TARGET_BIN=$(find /ps-files -type f -name "psclient" -executable | grep "amd64" | head -n 1) \n\
BIN_DIR=$(dirname "$TARGET_BIN") \n\
echo "Found x64 Binary at: $TARGET_BIN" \n\
\n\
# 2. Uske folder mein ja kar chalao taake launcher mil jaye \n\
cd "$BIN_DIR" \n\
./psclient -cid=$CID & \n\
\n\
# 3. Wapas app folder mein aa kar server chalao \n\
cd /app \n\
node server.js' > start.sh && chmod +x start.sh

ENTRYPOINT []
CMD ["./start.sh"]
