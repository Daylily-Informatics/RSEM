FROM ubuntu:22.04

ARG STAR_VERSION=2.7.11b
ENV STAR_VERSION=${STAR_VERSION}

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
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

# Install STAR aligner version matching Snakemake wrapper v3.5.3/bio/star/align
RUN wget -qO /tmp/star.zip "https://github.com/alexdobin/STAR/releases/download/${STAR_VERSION}/STAR_${STAR_VERSION}.zip" \
    && unzip -q /tmp/star.zip -d /opt \
    && install -m 0755 /opt/STAR_${STAR_VERSION}/Linux_x86_64_static/* /usr/local/bin/ \
    && rm -rf /opt/STAR_${STAR_VERSION} /tmp/star.zip

# Set working directory
WORKDIR /opt/rsem

# Copy source
COPY . /opt/rsem

# Build and install RSEM
RUN make && make install

ENV PATH="/usr/local/bin:/usr/bin:${PATH}"

CMD ["bash"]
