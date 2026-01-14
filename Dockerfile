# Use a lightweight web server
FROM nginx:alpine

# Copy our HTML file to the server's directory
COPY index.html /usr/share/nginx/html/index.html