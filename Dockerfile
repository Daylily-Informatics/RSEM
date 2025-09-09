FROM ubuntu:22.04

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    make \
    perl \
    python3 \
    r-base \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/rsem

# Copy source
COPY . /opt/rsem

# Build and install RSEM
RUN make && make install

ENV PATH="/usr/local/bin:${PATH}"

CMD ["bash"]
