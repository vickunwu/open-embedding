FROM ghcr.io/huggingface/text-embeddings-inference:cpu-latest

ARG S6_ARCH=x86_64
ARG CADDY_ARCH=linux_amd64

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y curl && \
  rm -rf /var/lib/apt/lists/* && \
  curl -sfL -o /tmp/s6-overlay-noarch.tar.xz https://glare.now.sh/just-containers/s6-overlay/s6-overlay-noarch.tar.xz && \
  curl -sfL -o /tmp/s6-overlay-${S6_ARCH}.tar.xz https://glare.now.sh/just-containers/s6-overlay/s6-overlay-${S6_ARCH}.tar.xz && \
  curl -sfL -o /tmp/${CADDY_ARCH}.tar.gz https://glare.now.sh/${CADDY_ARCH}.tar.gz && \
  tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
  tar -C / -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz && \
  tar zxf /tmp/${CADDY_ARCH}.tar.gz -C /usr/bin/ caddy && \
  rm /tmp/*.tar.* && \
  mkdir -p /data && \
  ln -s /run /var/run

COPY docker/rootfs /

ENV HUGGINGFACE_HUB_CACHE=/data \
    PORT=3000 \
    MODEL_ID=BAAI/bge-base-en-v1.5 \
    REVISION=refs/pr/1

HEALTHCHECK --interval=10s --timeout=5s CMD /usr/bin/healthcheck.sh

ENTRYPOINT ["/init"]
