# Step 1: Repocket ki official image
FROM repocket/repocket:latest

# Step 2: Root user ban kar Node.js install karein (Port bypass ke liye)
USER root
RUN apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Step 3: Dummy server script (Render ko 24/7 zinda rakhne ke liye)
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("Repocket is running on Render"); \
}).listen(process.env.PORT || 8080);' > server.js

# Step 4: Start command
# Ye command environment variables ($RP_EMAIL aur $RP_API_KEY) se values khud uthayegi
CMD node server.js & ./repocket -email "$RP_EMAIL" -api_key "$RP_API_KEY"
