# Step 1: Force AMD64 (Is baar hum koi search-search nahi khelein ge)
FROM --platform=linux/amd64 packetstream/psclient:latest

USER root
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Dummy server for Render
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is running"); \
}).listen(process.env.PORT || 8080);' > server.js

# Reset Entrypoint
ENTRYPOINT []

# Command: Hum direct binary ka sahi path use karenge jo unki image mein hota hai
# Aur flag ko quotes mein rakhenge taake -c wala error na aaye
CMD ["/bin/sh", "-c", "/usr/local/bin/psclient -cid=$CID & node server.js"]
