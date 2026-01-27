FROM debian:bookworm-slim

# Step 1: Zaroori softwares install karein
RUN apt-get update && apt-get install -y curl nodejs ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Step 2: Google Drive se 11MB wali binary download karein
# Humne 'confirm' query add ki hai taake Google ka virus scan warning bypass ho jaye
RUN curl -L "https://docs.google.com/uc?export=download&confirm=$(curl -sL 'https://docs.google.com/uc?export=download&id=1zeHrToVLepfUFIHFwarinb1evz6LKHUd' | grep -o 'confirm=[^&]*' | sed 's/confirm=//')&id=1zeHrToVLepfUFIHFwarinb1evz6LKHUd" -o psclient && \
    chmod +x psclient

# Step 3: Render Health Check Server
RUN echo 'require("http").createServer((req, res) => { \
    res.writeHead(200); \
    res.end("PacketStream Client is Active"); \
}).listen(process.env.PORT || 8080);' > server.js

# Step 4: Binary chalane ka final tareeqa
# Naye versions mein '-c' ki jagah '--cid' (double dash) chalta hai
# Saath mein humne 'export' bhi kar diya hai taake binary direct utha sake
CMD export CID=$CID && ./psclient --cid=$CID & node server.js
