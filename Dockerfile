FROM repocket/repocket:latest

USER root
RUN apk add --no-cache nodejs

WORKDIR /app

# Dummy server for Render
RUN echo 'const http = require("http"); \
const port = process.env.PORT || 8080; \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("OK"); \
}).listen(port, "0.0.0.0");' > server.js

RUN chmod +x ./repocket

# Naya logic: Repocket ke logs ko 'tail' karenge taake Render terminal par nazar aayein
CMD ["/bin/sh", "-c", "./repocket -email ${RP_EMAIL} -api_key ${RP_API_KEY} > /app/re.log 2>&1 & sleep 2 && tail -f /app/re.log & node server.js"]
