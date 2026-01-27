FROM --platform=linux/amd64 packetstream/psclient:latest AS ps-source
FROM --platform=linux/amd64 debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
WORKDIR /app

COPY --from=ps-source / /ps-files/

RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream Node is trying to connect..."); \
}).listen(process.env.PORT || 8080);' > server.js

# Sub se powerful script jo har variation try karegi
RUN echo '#!/bin/sh \n\
TARGET_BIN=$(find /ps-files -type f -name "psclient" -executable | grep -v "arm" | head -n 1) \n\
echo "Using Binary: $TARGET_BIN" \n\
echo "Trying different flag formats for CID: $CID" \n\
\n\
# Try 1: Environment Variable (Aksar Docker images isi se chalti hain) \n\
export CID=$CID \n\
$TARGET_BIN & \n\
\n\
# Try 2: Combined flag (Agar pehla fail hua) \n\
$TARGET_BIN -cid=$CID & \n\
\n\
# Try 3: Simple argument (No flag) \n\
$TARGET_BIN $CID & \n\
\n\
node server.js' > start.sh && chmod +x start.sh

ENTRYPOINT []
CMD ["./start.sh"]
