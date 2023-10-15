FROM ghcr.io/huggingface/text-embeddings-inference:cpu-latest

ARG S6_ARCH=x86_64

ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-noarch.tar.xz /
ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-${S6_ARCH}.tar.xz /
ADD https://caddyserver.com/api/download?os=linux&arch=amd64 /usr/bin/caddy

RUN \
  chmod +x /usr/bin/caddy && \
  ln -s /run /var/run

COPY docker/rootfs /

ENV HUGGINGFACE_HUB_CACHE=/data \
    PORT=3000 \
    MODEL_ID=BAAI/bge-base-en-v1.5 \
    REVISION=refs/pr/1

HEALTHCHECK --interval=10s --timeout=5s CMD /usr/bin/healthcheck.sh

ENTRYPOINT ["/init"]
