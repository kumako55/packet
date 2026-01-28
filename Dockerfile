# Step 1: Use official Repocket image
FROM repocket/repocket:latest

# Step 2: Use root to install nodejs (Alpine style)
USER root
RUN apk add --no-cache nodejs

WORKDIR /app

# Step 3: Dummy server for Render (Port 8080)
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("Repocket is active"); \
}).listen(process.env.PORT || 8080);' > server.js

# Step 4: Final Start Command
# Environment Variables ($RP_EMAIL, $RP_API_KEY) Render dashboard se uthayega
CMD node server.js & ./repocket -email "$RP_EMAIL" -api_key "$RP_API_KEY"
