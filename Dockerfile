FROM repocket/repocket:latest

USER root
# Alpine mein nodejs install karein
RUN apk add --no-cache nodejs

WORKDIR /app

# Dummy server jo Render ki PORT environment variable ko listen karega
RUN echo 'const http = require("http"); \
const port = process.env.PORT || 8080; \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("ALIVE"); \
}).listen(port, "0.0.0.0", () => { \
  console.log("Render Port Monitor started on port " + port); \
});' > server.js

# Start command: Node server ko background mein lazmi chalana hai
CMD node server.js & ./repocket -email "$RP_EMAIL" -api_key "$RP_API_KEY"
