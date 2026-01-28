FROM repocket/repocket:latest

USER root
# Alpine mein nodejs install karein
RUN apk add --no-cache nodejs

WORKDIR /app

# Dummy server script
RUN echo 'const http = require("http"); \
const port = process.env.PORT || 8080; \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("Repocket is active and listening"); \
}).listen(port, "0.0.0.0", () => { \
  console.log("Render Port Monitor started on port " + port); \
});' > server.js

# Binary ko permission dein (Just in case)
RUN chmod +x ./repocket

# FINAL CMD: Repocket ko background (&) mein aur Node ko foreground mein
CMD ["/bin/sh", "-c", "./repocket -email ${RP_EMAIL} -api_key ${RP_API_KEY} & node server.js"]
