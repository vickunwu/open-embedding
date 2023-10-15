FROM ghcr.io/huggingface/text-embeddings-inference:cpu-latest

ARG S6_ARCH=x86_64
ARG CADDY_ARCH=linux_amd64
ADD https://glare.now.sh/just-containers/s6-overlay/s6-overlay-noarch.tar.xz /tmp
ADD https://glare.now.sh/just-containers/s6-overlay/s6-overlay-${S6_ARCH}.tar.xz /tmp
ADD https://glare.now.sh/${CADDY_ARCH}.tar.gz /tmp
RUN \
  tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
  tar -C / -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz && \
  tar zxf /tmp/${CADDY_ARCH}.tar.gz -C /usr/bin/ caddy && \
  rm /tmp/*.tar.* & \
  ln -s /run /var/run

COPY docker/rootfs /

ENV HUGGINGFACE_HUB_CACHE=/data \
    PORT=3000 \
    MODEL_ID=BAAI/bge-base-en-v1.5 \
    REVISION=refs/pr/1

HEALTHCHECK --interval=10s --timeout=5s CMD /usr/bin/healthcheck.sh

ENTRYPOINT ["/init"]
