# Step 1: Base image
FROM packetstream/psclient:latest

# Step 2: Root user ban kar Node install karein
USER root
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Dummy server setup
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is running"); \
}).listen(process.env.PORT || 8080);' > server.js

# IMPORTANT: Purana entrypoint khatam karne ke liye
ENTRYPOINT []

# Ab command sahi chalegi
CMD ["/bin/sh", "-c", "psclient -cid ${CID} & node server.js"]
