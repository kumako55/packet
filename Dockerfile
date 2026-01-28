FROM repocket/repocket:latest

USER root
# Netcat install karein jo port handle karega
RUN apk add --no-cache netcat-openbsd

WORKDIR /app

# Final Command: Port 8080 ko "Forcefully" open rakhenge
# Repocket background mein chalega aur Netcat loop mein Render ko signal dega
CMD ["/bin/sh", "-c", "./repocket -email ${RP_EMAIL} -api_key ${RP_API_KEY} & while true; { printf 'HTTP/1.1 200 OK\r\nContent-Length: 2\r\n\r\nOK' | nc -l -p ${PORT:-8080}; }"]
