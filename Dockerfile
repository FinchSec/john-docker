FROM debian:unstable as builder
# hadolint ignore=DL3005,DL3008,DL3015,DL3009,SC2046
RUN sed -i 's/main/main non-free non-free-firmware contrib/' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install ca-certificates git gcc make libssl-dev zlib1g-dev yasm \
                    $([ "$(dpkg --print-architecture)" = "armel" ] && echo pocl-opencl-icd pocl-opencl-icd ocl-icd-opencl-dev) \
                    $([ "$(dpkg --print-architecture)" = "armhf" ] && echo pocl-opencl-icd pocl-opencl-icd ocl-icd-opencl-dev) \
                    $([ "$(dpkg --print-architecture)" = "ppc64el" ] && echo nvidia-opencl-dev ocl-icd-opencl-dev) \
                    $([ "$(dpkg --print-architecture)" = "arm64" ] && echo ocl-icd-opencl-dev nvidia-opencl-dev pocl-opencl-icd) \
                    $([ "$(dpkg --print-architecture)" = "amd64" ] && echo pocl-opencl-icd ocl-icd-opencl-dev nvidia-opencl-dev pocl-opencl-icd) \
                    $([ "$(dpkg --print-architecture)" = "i386" ] && echo pocl-opencl-icd pocl-opencl-icd) \
                    $([ "$(dpkg --print-architecture)" = "riscv64" ] && echo ocl-icd-opencl-dev) \
                    $([ "$(dpkg --print-architecture)" = "s390x" ] && echo ocl-icd-opencl-dev) \
                    pkg-config libgmp-dev libpcap-dev libbz2-dev opencl-headers libc6-dev \
                    -y --no-install-recommends
# hadolint ignore=DL3059
RUN git clone https://github.com/openwall/john -b bleeding-jumbo john
WORKDIR /john/src
# hadolint ignore=SC2046
RUN ./configure --with-systemwide --enable-nt-full-unicode \
    $([ "$(dpkg --print-architecture)" = "riscv64" ] && echo "--build=riscv64-unknown-linux-gnu") && \
    make -s clean && \
    make && \
    make install

COPY install.sh /john
RUN bash ../install.sh

WORKDIR /john-bin/
RUN tar -czf /john.tar.gz ./*


FROM debian:unstable-slim
LABEL org.opencontainers.image.authors="thomas@finchsec.com"
# hadolint ignore=DL3005,DL3008,SC2046
RUN sed -i 's/main/main non-free non-free-firmware contrib/' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get dist-upgrade -y && \
        apt-get install zlib1g libc6 libgmp10 libpcap0.8 libbz2-1.0 \
                        $([ "$(dpkg --print-architecture)" = "armel" ] && echo pocl-opencl-icd) \
                        $([ "$(dpkg --print-architecture)" = "armhf" ] && echo pocl-opencl-icd) \
                        $([ "$(dpkg --print-architecture)" = "arm64" ] && echo nvidia-opencl-icd nvidia-opencl-dev pocl-opencl-icd ) \
                        $([ "$(dpkg --print-architecture)" = "amd64" ] && echo nvidia-opencl-icd nvidia-opencl-dev pocl-opencl-icd) \
                        $([ "$(dpkg --print-architecture)" = "i386" ] && echo nvidia-opencl-icd pocl-opencl-icd) \
                        python3 ruby lua5.4 perl --no-install-recommends -y && \
        apt-get autoclean && \
		rm -rf /var/lib/dpkg/status-old /var/lib/apt/lists/* && \
        mkdir -p /root/.john/opencl

COPY --from=builder /john.tar.gz /
RUN tar -zxf john.tar.gz && \
    rm john.tar.gz
