# Use a lightweight base image
FROM ubuntu

# Set environment variables to avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libcurl4 \
    libstdc++6 \
    libgcc1 \
    screen \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a user and set up the working directory
RUN useradd -m bedrock
WORKDIR /home/bedrock

# Download and extract the Minecraft Bedrock server
ENV VERSION=1.21.84.01

COPY bedrock-server-1.21.84.1.zip bedrock-server.zip
RUN unzip bedrock-server.zip && \
    rm bedrock-server.zip && \
    chmod +x bedrock_server

# Copy default config files (optional)
COPY ./server.properties ./permissions.json ./

# Change ownership
RUN chown -R bedrock:bedrock .

# Switch to the bedrock user
USER bedrock

# Expose the Bedrock server default port
EXPOSE 19132/udp

# Run the server
CMD ["./bedrock_server"]