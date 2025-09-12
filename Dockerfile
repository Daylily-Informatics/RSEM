FROM ubuntu:22.04

# Avoid interactive prompts and set a default timezone
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    build-essential \
    g++ \
    make \
    perl \
    python3 \
    r-base \
    tzdata \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    bowtie \
    bowtie2 \
    samtools \
    tabix \
    && rm -rf /var/lib/apt/lists/* \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

# Set working directory
WORKDIR /opt/rsem

# Copy source
COPY . /opt/rsem

# Build and install RSEM
RUN make && make install

ENV PATH="/usr/local/bin:/usr/bin:${PATH}"

CMD ["bash"]
