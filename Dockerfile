FROM repocket/repocket:latest

USER root
RUN apk add --no-cache nodejs

WORKDIR /app

# Ye script check karega ke Repocket chalta rahe aur Port hamesha open rahe
RUN echo 'const http = require("http"); \
const server = http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("OK"); \
}); \
const port = process.env.PORT || 8080; \
server.listen(port, "0.0.0.0", () => { \
  console.log("PORT_OPEN_SUCCESS_" + port); \
});' > server.js

# Binary ko execute permission aur Environment variables ko handle karne ka tareeqa
# Yahan hum 'sh -c' use karenge taake shell properly background process handle kare
CMD ["/bin/sh", "-c", "node server.js & ./repocket -email ${RP_EMAIL} -api_key ${RP_API_KEY}"]
