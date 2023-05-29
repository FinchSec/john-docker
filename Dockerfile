FROM debian:unstable as builder
# hadolint ignore=DL3005,DL3008,DL3015,DL3009,SC2046
RUN sed -i 's/main/main non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install ca-certificates git gcc make libssl-dev zlib1g-dev yasm \
                    $([ "$(uname -m)" != "armv7l" ] && echo pocl-opencl-icd nvidia-opencl-dev) \
                    $([ "$(uname -m)" = "x86_64" ] && echo intel-opencl-icd) \
                    pkg-config libgmp-dev libpcap-dev libbz2-dev \
                    ocl-icd-opencl-dev opencl-headers pocl-opencl-icd libc6-dev \
                    -y --no-install-recommends
RUN git clone https://github.com/openwall/john -b bleeding-jumbo john
WORKDIR /john/src
RUN ./configure CPPFLAGS='-DCPU_FALLBACK' --with-systemwide --enable-nt-full-unicode && make -s clean && \
    make && \
    make install

COPY install.sh /john
RUN bash ../install.sh

WORKDIR /john-bin/
RUN tar -czf /john.tar.gz ./*


FROM debian:unstable-slim
LABEL org.opencontainers.image.authors="thomas@finchsec.com"
# hadolint ignore=DL3005,DL3008,SC2046
RUN sed -i 's/main/main non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get dist-upgrade -y && \
        apt-get install zlib1g libc6 nvidia-opencl-dev libgmp10 libpcap0.8 libbz2-1.0 \
                        ocl-icd-opencl-dev opencl-headers libc6-dev \
                        $([ "$(uname -m)" != "armv7l" ] && echo pocl-opencl-icd nvidia-opencl-dev) \
                        $([ "$(uname -m)" = "x86_64" ] && echo intel-opencl-icd) \
                        --no-install-recommends -y && \
        apt-get autoclean && \
		rm -rf /var/lib/dpkg/status-old /var/lib/apt/lists/* && \
        mkdir -p /root/.john/opencl

COPY --from=builder /john.tar.gz /
RUN tar -zxf john.tar.gz && \
    rm john.tar.gz
