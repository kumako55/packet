FROM repocket/repocket:latest

USER root
RUN apk add --no-cache nodejs npm

WORKDIR /app

# Majboot Server Logic
RUN echo 'const http = require("http"); \
const server = http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("OK"); \
}); \
server.listen(process.env.PORT || 8080, "0.0.0.0", () => { \
  console.log("RENDER_PORT_LOCKED"); \
});' > server.js

# Process Manager: Node ko pehle chalayein taake port foran open ho jaye
CMD ["/bin/sh", "-c", "node server.js & sleep 5 && npm start -- -email ${RP_EMAIL} -api_key ${RP_API_KEY}"]
