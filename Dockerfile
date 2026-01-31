FROM repocket/repocket:latest

USER root
WORKDIR /app

# 1. Zaruri tools (iproute2 system ki speed optimize karne ke liye)
RUN apk add --no-cache express bash iproute2

# 2. Server.js - Jis mein Single Engine ki Speed barhai gayi hai
RUN cat <<EOF > /app/server.js
const { spawn } = require('child_process');
const express = require('express');
const app = express();
const port = 7860;

app.get('/', (req, res) => {
    res.send('<body style="background:#000; display:flex; justify-content:center; align-items:center; height:100vh; margin:0;">' +
             '<span style="font-size:50px; filter: drop-shadow(0 0 15px #00ffff);">🚀</span></body>');
});

app.listen(port, '0.0.0.0', () => {
    console.log('Single High-Performance Engine starting...');
    
    // Engine ko 'nice' command ke sath chalana (Priority -20 = Sabse zyada CPU/Network)
    // Is se process ko internet line pe pehla haq milta hai
    const child = spawn('nice', [
        '-n', '-20', 
        'node', '/app/dist/index.js', 
        '-e', process.env.RP_EMAIL, 
        '-p', process.env.RP_API_KEY
    ]);

    child.stdout.on('data', (data) => { 
        // Console par sirf 1MB/s ki monitoring logs dikhana
        console.log(\`Engine: \${data}\`.trim()); 
    });

    child.on('close', () => {
        console.log('Engine stopped. Re-igniting for 1MB/s delivery...');
        process.exit(1); // Space auto-restart hogi
    });
});
EOF

# 3. --- NETWORK TWEAKS FOR 1MB/S ---
# TCP Window Scaling aur Buffers ko expand karna
RUN echo "net.ipv4.tcp_window_scaling=1" >> /etc/sysctl.conf && \
    echo "net.ipv4.tcp_low_latency=1" >> /etc/sysctl.conf && \
    echo "net.core.rmem_default=262144" >> /etc/sysctl.conf && \
    echo "net.core.wmem_default=262144" >> /etc/sysctl.conf

EXPOSE 7860
ENTRYPOINT []

# 4. Start command
CMD ["node", "server.js"]
