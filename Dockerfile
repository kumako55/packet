# Step 1: Seedha PacketStream ki image ko hi use karein
FROM packetstream/psclient:latest

# Step 2: Alpine ke packages manual install karne ke bajaye 
# hum sirf nodejs add karenge (PacketStream image Debian based hoti hai)
USER root
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Dummy server for Render health check
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is running perfectly"); \
}).listen(process.env.PORT || 8080);' > server.js

# PacketStream ki apni binary 'psclient' ke naam se hi hoti hai system path mein
# Hum use background mein chalayenge aur node server foreground mein
CMD psclient -cid ${CID} & node /app/server.js
