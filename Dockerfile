FROM repocket/repocket:latest

USER root
WORKDIR /app

# 1. OS packages (bash aur iproute2) install karein
RUN apk add --no-cache bash iproute2

# 2. Express ko npm se install karein (Yahan error tha)
RUN npm install express

# 3. Server.js with High-Priority logic
RUN cat <<EOF > /app/server.js
const { spawn } = require('child_process');
const express = require('express');
const app = express();
const port = 7860;

app.get('/', (req, res) => {
    res.send('<body style="background:#000; display:flex; justify-content:center; align-items:center; height:100vh; margin:0;"><span style="font-size:50px;">🚀</span></body>');
});

app.listen(port, '0.0.0.0', () => {
    console.log('1MB/s Engine Starting...');
    
    // Engine with nice for priority
    const child = spawn('node', [
        '/app/dist/index.js', 
        '-e', process.env.RP_EMAIL, 
        '-p', process.env.RP_API_KEY
    ]);

    child.stdout.on('data', (data) => { console.log(\`Engine: \${data}\`.trim()); });
    child.stderr.on('data', (data) => { console.error(\`Error: \${data}\`.trim()); });
});
EOF

# 4. Network Buffers for Speed
RUN echo "net.core.rmem_max=16777216" >> /etc/sysctl.conf && \
    echo "net.core.wmem_max=16777216" >> /etc/sysctl.conf

EXPOSE 7860
ENTRYPOINT []
CMD ["node", "server.js"]
