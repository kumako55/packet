FROM repocket/repocket:latest

USER root
WORKDIR /app

# 1. Zaruri Tools
RUN apk add --no-cache bash iproute2
RUN npm install express

# 2. Optimized server.js (Logs & Traffic Fix)
RUN cat <<EOF > /app/server.js
const { spawn } = require('child_process');
const express = require('express');
const app = express();
const port = 7860;

app.get('/', (req, res) => {
    res.send('<body style="background:#000; display:flex; justify-content:center; align-items:center; height:100vh; margin:0;"><span style="font-size:50px;">🚀</span></body>');
});

// Server start hone par Repocket ko force-start karna
app.listen(port, '0.0.0.0', () => {
    console.log('--- EXCLUSIVE 1MB/S ENGINE STARTING ---');
    
    const child = spawn('node', [
        '/app/dist/index.js', 
        '-e', process.env.RP_EMAIL, 
        '-p', process.env.RP_API_KEY
    ], {
        stdio: ['inherit', 'pipe', 'pipe'], // Logs ko pipe karna zaruri hai
        env: { ...process.env, NODE_ENV: 'production' }
    });

    // Logs ko Express console par redirect karna (Takay connection active rahay)
    child.stdout.on('data', (data) => {
        const output = data.toString();
        process.stdout.write(output); // Ye logs ko HF ke main console par dikhayega
    });

    child.stderr.on('data', (data) => {
        process.stderr.write(data.toString());
    });

    child.on('close', (code) => {
        console.log('Engine died with code ' + code + '. Rebooting...');
        process.exit(1);
    });
});
EOF

# 3. Network Force (Taake shared internet par priority milay)
RUN echo "net.ipv4.tcp_slow_start_after_idle=0" >> /etc/sysctl.conf

EXPOSE 7860
ENTRYPOINT []
CMD ["node", "server.js"]
