FROM repocket/repocket:latest AS source

FROM alpine:latest

RUN apk add --no-cache nodejs

WORKDIR /app

# Source se files copy karein
COPY --from=source /app /app

# Sab executables ko permission dein lekin .npmrc ko ignore karein
RUN find /app -type f -not -name "*.npmrc" -exec chmod +x {} +

# Dummy server
RUN echo 'const http = require("http"); \
const port = process.env.PORT || 8080; \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("OK"); \
}).listen(port, "0.0.0.0");' > server.js

# Binary dhoondo (sirf woh jo .npmrc ya .js nahi hain)
CMD ["/bin/sh", "-c", "export BIN=$(find /app -type f -maxdepth 1 -executable -not -name '.*' -not -name '*.js' | head -n 1); \
    echo \"Asli Binary Mili: $BIN\"; \
    $BIN -email $RP_EMAIL -api_key $RP_API_KEY & \
    node server.js"]
