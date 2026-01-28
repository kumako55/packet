FROM repocket/repocket:latest

USER root
# Alpine mein node aur npm pehle se hote hain, lekin hum confirm kar lete hain
RUN apk add --no-cache nodejs npm

WORKDIR /app

# Dummy server logic
RUN echo 'const http = require("http"); \
const port = process.env.PORT || 8080; \
http.createServer((req, res) => { \
  res.writeHead(200); \
  res.end("OK"); \
}).listen(port, "0.0.0.0");' > render_port.js

# Hum direct npm use karenge jo Repocket ka standard tareeqa hai
# Aur variables ko properly pass karenge
CMD ["/bin/sh", "-c", "npm start -- -email ${RP_EMAIL} -api_key ${RP_API_KEY} & node render_port.js"]
