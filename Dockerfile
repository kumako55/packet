FROM --platform=linux/amd64 packetstream/psclient:latest AS ps-source
FROM --platform=linux/amd64 debian:bookworm-slim

RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# 1. Binary ko dhoond kar seedha /app mein copy kar lo
COPY --from=ps-source /usr/local/bin/linux_amd64/psclient /app/psclient
RUN chmod +x /app/psclient

# 2. Dummy server
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream Force Started"); \
}).listen(process.env.PORT || 8080);' > server.js

# 3. Bilkul saaf script (No hidden flags)
RUN echo '#!/bin/sh \n\
echo "Current CID is: $CID" \n\
# Hum yahan flag use nahi kar rahe, direct help mang rahe hain pehle \n\
./psclient -id=$CID & \n\
node server.js' > start.sh && chmod +x start.sh

ENTRYPOINT []
# Purani layers ko bypass karne ke liye direct shell call
CMD ["/bin/sh", "/app/start.sh"]
