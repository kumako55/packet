FROM repocket/repocket:latest AS source

# Step 2: Runtime
FROM alpine:latest

# Zaroori packages
RUN apk add --no-cache nodejs

WORKDIR /app

# Source se files copy karein
COPY --from=source /app /app

# Har executable ko permission dein (Error se bachne ke liye)
RUN find /app -type f -exec chmod +x {} +

# Dummy server logic (Render Port Fix)
RUN echo 'const http = require("http"); \
const port = process.env.PORT || 8080; \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("Repocket is running"); \
}).listen(port, "0.0.0.0");' > server.js

# Binary dhoondo aur uske logs dikhao
CMD ["/bin/sh", "-c", "export BIN=$(find /app -type f -maxdepth 1 -executable -not -name '*.js' | head -n 1); \
    echo \"Starting Binary: $BIN\"; \
    $BIN -email $RP_EMAIL -api_key $RP_API_KEY > /app/re.log 2>&1 & \
    sleep 3 && tail -f /app/re.log & \
    node server.js"]
