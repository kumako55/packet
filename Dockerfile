# Step 1: PacketStream ki official image se binary uthao
FROM packetstream/psclient:latest AS ps-source

# Step 2: Runtime Image
FROM alpine:latest

# Zaroori packages aur compatibility layer
RUN apk add --no-cache nodejs libc6-compat gcompat

WORKDIR /app

# Official image se binary copy karein (No download needed!)
COPY --from=ps-source /usr/local/bin/psclient /app/psclient
RUN chmod +x /app/psclient

# Dummy server for Render health check
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is running via Multi-Stage Build"); \
}).listen(process.env.PORT || 8080);' > server.js

# Command jo environment variable $CID ko use karegi
CMD ["/bin/sh", "-c", "./psclient -cid ${CID} & node server.js"]
