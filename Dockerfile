FROM repocket/repocket:latest

USER root
RUN apk add --no-cache nodejs npm

WORKDIR /app

# Sab se important: Server jo har 1 second baad Render ko "Signal" dega
RUN echo 'const http = require("http"); \
const port = process.env.PORT || 8080; \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("I AM ALIVE"); \
}).listen(port, "0.0.0.0", () => { \
  console.log("SERVER_LISTENING_ON_PORT_" + port); \
}); \
setInterval(() => { console.log("KEEP_ALIVE_SIGNAL"); }, 30000);' > server.js

# Repocket ko background mein aur Node ko foreground mein (Taake Render port detect kar le)
CMD ["/bin/sh", "-c", "npm start -- -email ${RP_EMAIL} -api_key ${RP_API_KEY} & node server.js"]
