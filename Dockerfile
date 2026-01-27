FROM alpine:latest

# Zaroori packages aur compatibility layer
RUN apk add --no-cache nodejs wget libc6-compat

WORKDIR /app

# PacketStream binary download
RUN wget -qO /app/psclient https://packetstream.io/static/bin/psclient-linux-x64 && \
    chmod +x /app/psclient

# Dummy server for Render
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream Node is Active"); \
}).listen(process.env.PORT || 8080);' > server.js

# Command jo environment variable $CID ko use karegi
CMD ["/bin/sh", "-c", "./psclient -cid $CID & node server.js"]
