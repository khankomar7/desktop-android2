FROM lscr.io/linuxserver/webtop:ubuntu-xfce

ARG TARGETARCH=amd64
RUN test "$TARGETARCH" = "amd64" || (echo "This project targets linux/amd64; received $TARGETARCH" >&2 && exit 1)

LABEL maintainer="you"
LABEL description="Android-first remote desktop for Claude Desktop and Claude Code"

# ---- System deps ----
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl gnupg ca-certificates \
        wget unzip \
        fonts-liberation \
        dbus-x11 \
        xauth \
        xvfb \
        libnotify-bin \
        jq && \
    rm -rf /var/lib/apt/lists/*

# ---- Node.js 20 ----
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install -g @anthropic-ai/claude-code && \
    rm -rf /var/lib/apt/lists/*

# ---- Claude Desktop ----
RUN curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc \
      https://downloads.claude.ai/claude-desktop/key.asc && \
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" \
      > /etc/apt/sources.list.d/claude-desktop.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends claude-desktop && \
    rm -rf /var/lib/apt/lists/*

# ---- Android performance script ----
COPY bin/android-perf.sh /usr/local/bin/android-perf.sh
COPY autostart/android-perf.desktop /etc/xdg/autostart/android-perf.desktop
RUN chmod +x /usr/local/bin/android-perf.sh

# ---- Mobile-friendly defaults ----
ENV PUID=1000 \
    PGID=1000 \
    TZ=Asia/Tehran \
    MAX_RES=1280x720 \
    SELKIES_ENCODER=x264enc-striped \
    SELKIES_FRAMERATE=24 \
    SELKIES_H264_CRF=30

# webtop exposes:
#   3000 -> HTTP
#   3001 -> HTTPS
