# Step 1: Repocket source
FROM repocket/repocket:latest AS source

# Step 2: Runtime
FROM alpine:latest

# Zaroori packages
RUN apk add --no-cache nodejs

WORKDIR /app

# Source se files copy karein
COPY --from=source /app /app

# Sab binaries ko execute permission dein
RUN chmod -R +x /app

# Dummy server logic jo Render ko pasand hai
RUN echo 'const http = require("http"); \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("Repocket is running"); \
}).listen(process.env.PORT || 8080);' > server.js

# Aapka favorite logic: Binary dhoondo aur Render port ke saath chalao
CMD ["/bin/sh", "-c", "export BIN=$(find /app -type f -maxdepth 1 -executable -not -name '*.js' | head -n 1); echo \"Found Binary: $BIN\"; $BIN -email $RP_EMAIL -api_key $RP_API_KEY & node server.js"]
