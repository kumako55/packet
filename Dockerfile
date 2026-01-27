FROM alpine:latest

# Zaroori packages
RUN apk add --no-cache nodejs curl libc6-compat gcompat

WORKDIR /app

# PacketStream binary download (Added User-Agent to avoid blocked download)
RUN curl -L -A "Mozilla/5.0" https://packetstream.io/static/bin/psclient-linux-x64 -o /app/psclient && \
    chmod +x /app/psclient

# Dummy server for Render health check
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is active"); \
}).listen(process.env.PORT || 8080);' > server.js

# Command: CID variable lazmi Render mein set kariyega
CMD ["/bin/sh", "-c", "./psclient -cid ${CID} & node server.js"]
