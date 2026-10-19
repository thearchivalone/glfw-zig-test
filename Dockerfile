#
# Copyright 2026 - Brad D
# See LICENSE for copyright information.
# Please include this header and that license for any derivative works.
# NOTE: Only the documentation, tools and anything that's not directly a part
# of the game's data fall under this copyright. I don't claim any ownership of
# the game or any of its assets
#

FROM debian:bookworm-slim AS base
ENV SRC_DIR="/src"
RUN \
  apt-get update && \
  apt-get install -y \
    build-essential \
    pkg-config \
    libglfw3-dev \
    libx11-dev \
    libwayland-dev \
    libwayland-client0 \
    libwayland-client++1 \
    libasound-dev \
    bash \
    curl \
    zip \
    tar \
    xz-utils

FROM base AS prepare
ENV PATH="$PATH:/root/.local/bin"
ENV PREFIX="zig-out"
RUN \
  curl -L https://github.com/marler8997/anyzig/releases/latest/download/anyzig-x86_64-linux.tar.gz | tar xz && \
  mkdir -p ~/.local/bin && \
  mv zig ~/.local/bin && \
  cd /tmp && \
  zig 0.17.0 init

FROM prepare AS builder
WORKDIR $SRC_DIR
COPY --link . $SRC_DIR
CMD ["bash", "-c", "./compile.sh"]
