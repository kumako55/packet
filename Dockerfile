FROM --platform=linux/amd64 packetstream/psclient:latest AS ps-source
FROM --platform=linux/amd64 debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=ps-source / /ps-files/

RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream Node is Live"); \
}).listen(process.env.PORT || 8080);' > server.js

# Script jo sahi binary dhoond kar aur sahi flag ke sath chalayega
RUN echo '#!/bin/sh \n\
TARGET_BIN=$(find /ps-files -type f -name "psclient" -executable | grep "amd64" | head -n 1) \n\
BIN_DIR=$(dirname "$TARGET_BIN") \n\
echo "Found x64 Binary at: $TARGET_BIN" \n\
\n\
cd "$BIN_DIR" \n\
\n\
# Try 1: Double dash (Modern standard) \n\
./psclient --cid $CID & \n\
sleep 2 \n\
\n\
# Try 2: Single flag -c (Agar wo -cid ko -c samajh raha hai) \n\
./psclient -c $CID & \n\
sleep 2 \n\
\n\
# Try 3: No flag (Direct ID) \n\
./psclient $CID & \n\
\n\
cd /app \n\
node server.js' > start.sh && chmod +x start.sh

ENTRYPOINT []
CMD ["./start.sh"]
