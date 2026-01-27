FROM debian:bookworm-slim

# Step 1: Install dependencies
RUN apt-get update && apt-get install -y curl nodejs ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Step 2: Download ps_package.tar.gz from Google Drive
RUN curl -L "https://docs.google.com/uc?export=download&confirm=$(curl -sL 'https://docs.google.com/uc?export=download&id=1G4f_RdC6U2iZaQTRk934EDCqyCbmNFQR' | grep -o 'confirm=[^&]*' | sed 's/confirm=//')&id=1G4f_RdC6U2iZaQTRk934EDCqyCbmNFQR" -o ps_package.tar.gz

# Step 3: Extract and set permissions
RUN tar -xvzf ps_package.tar.gz && \
    chmod +x * && \
    rm ps_package.tar.gz

# Step 4: Health check server for Render
RUN echo 'require("http").createServer((req, res) => { res.writeHead(200); res.end("PacketStream Node is Live"); }).listen(process.env.PORT || 8080);' > server.js

# Step 5: Baghair flag ke chalayein (Sirf Environment Variable se)
# Hum 'CID' ko environment mein set kar rahe hain, binary khud utha legi
CMD export CID=$CID && ./psclient & node server.js
