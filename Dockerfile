FROM packetstream/psclient:latest

USER root
# Debian base par nodejs install karein
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Dummy server for Render
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("PacketStream is active"); \
}).listen(process.env.PORT || 8080);' > server.js

ENTRYPOINT []

# Binary ko dhoond kar chalane ka automatic tareeqa
CMD ["/bin/sh", "-c", "BIN_PATH=$(which psclient || find / -name psclient -type f -executable | head -n 1); $BIN_PATH -cid ${CID} & node server.js"]
