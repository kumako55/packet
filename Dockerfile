FROM alpine:latest

# Curl aur compatibility layers install karein
RUN apk add --no-cache nodejs curl libc6-compat

WORKDIR /app

# PacketStream binary download (Using curl instead of wget for better reliability)
RUN curl -L https://packetstream.io/static/bin/psclient-linux-x64 -o /app/psclient && \
    chmod +x /app/psclient

# Dummy server for Render health check
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is running"); \
}).listen(process.env.PORT || 8080);' > server.js

# Command jo environment variable $CID ko use karegi
CMD ["/bin/sh", "-c", "./psclient -cid $CID & node server.js"]
