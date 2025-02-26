# Use an official Node.js runtime as a parent image
FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire project
COPY . .

# Install MinIO Client
RUN apt-get update && apt-get install -y curl && \
    curl -O https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x mc && \
    mv mc /usr/local/bin/

# Copy the shell script and make it executable
COPY filebase.sh /usr/local/bin/filebase.sh
RUN chmod +x /usr/local/bin/filebase.sh

# Set the entry point
CMD ["node", "index.js"]
