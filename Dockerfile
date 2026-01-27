FROM --platform=linux/amd64 packetstream/psclient:latest AS ps-source
FROM --platform=linux/amd64 debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY --from=ps-source / /ps-files/

RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("Checking PacketStream Config..."); \
}).listen(process.env.PORT || 8080);' > server.js

# SCRIPT: No flags, strictly showing help and trying environment
RUN echo '#!/bin/sh \n\
TARGET_BIN=$(find /ps-files -type f -name "psclient" -executable | grep "amd64" | head -n 1) \n\
echo "--- DIAGNOSTIC START ---" \n\
echo "Binary found at: $TARGET_BIN" \n\
\n\
# 1. Ask the binary for help (Is se asli flag pata chalega) \n\
$TARGET_BIN --help || echo "Help command failed" \n\
\n\
# 2. Try running with environment variable ONLY (Strictly no flags) \n\
export CID=$CID \n\
cd $(dirname "$TARGET_BIN") \n\
./psclient & \n\
\n\
echo "--- DIAGNOSTIC END ---" \n\
cd /app \n\
node server.js' > start.sh && chmod +x start.sh

ENTRYPOINT []
# Zaroori: Har purani configuration ko overwrite karne ke liye
CMD ["/bin/sh", "/app/start.sh"]
