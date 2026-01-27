# Step 1: PacketStream ki image ko source banayein
FROM packetstream/psclient:latest AS ps-source

# Step 2: Runtime image
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Poori source image se files copy karein taake hum dhoond saken
COPY --from=ps-source / /ps-files/

# Dummy server for Render
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream Scanner Active"); \
}).listen(process.env.PORT || 8080);' > server.js

# SCRIPT: Jo executable binary dhoond kar chalaye ga
RUN echo '#!/bin/sh \n\
# Sari executable files dhoondo jo psclient ke naam se hain \n\
TARGET_BIN=$(find /ps-files -type f -name "psclient" -executable | head -n 1) \n\
echo "Found Binary at: $TARGET_BIN" \n\
if [ -z "$TARGET_BIN" ]; then \n\
  echo "Binary not found! Trying fallback..." \n\
  psclient -cid $CID & \n\
else \n\
  $TARGET_BIN -cid $CID & \n\
fi \n\
node server.js' > start.sh && chmod +x start.sh

# Run the script
CMD ["./start.sh"]
