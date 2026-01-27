FROM --platform=linux/amd64 packetstream/psclient:latest AS ps-source
FROM --platform=linux/amd64 debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Binary ko seedha target kar ke copy karein
COPY --from=ps-source /usr/local/bin/linux_amd64/psclient /app/psclient
RUN chmod +x /app/psclient

# Health check server
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is running"); \
}).listen(process.env.PORT || 8080);' > server.js

# FINAL ATTEMPT: Using only -c because it thinks -cid is -c -i -d
RUN echo '#!/bin/sh \n\
echo "Starting with -c flag..." \n\
./psclient -c $CID & \n\
node server.js' > start.sh && chmod +x start.sh

ENTRYPOINT []
CMD ["/bin/sh", "/app/start.sh"]
