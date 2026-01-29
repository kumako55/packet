FROM repocket/repocket:latest

USER root
WORKDIR /app

# 1. Express install karein
RUN npm install express

# 2. server.js banayein (Ab sirf aik emoji dashboard hoga)
RUN cat <<EOF > /app/server.js
const { spawn } = require('child_process');
const express = require('express');
const app = express();
const port = 7860;

// Bilkul saaf dashboard, sirf aik emoji
app.get('/', (req, res) => {
    res.send('<body style="background:#000; display:flex; justify-content:center; align-items:center; height:100vh; margin:0;">' +
             '<span style="font-size:50px;">🚀</span></body>');
});

app.listen(port, '0.0.0.0', () => {
    console.log('Stealth GUI live on ' + port);
    
    // Repocket engine background mein chalta rahay ga
    const child = spawn('node', [
        '/app/dist/index.js', 
        '-e', process.env.RP_EMAIL, 
        '-p', process.env.RP_API_KEY
    ]);

    child.stdout.on('data', (data) => { console.log(\`Engine: \${data}\`.trim()); });
    child.stderr.on('data', (data) => { console.error(\`Engine Error: \${data}\`.trim()); });
});
EOF

# 3. Port expose
EXPOSE 7860

# 4. Entrypoint bypass
ENTRYPOINT []

# 5. Start server
CMD ["node", "server.js"]
