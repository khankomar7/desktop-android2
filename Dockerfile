FROM lscr.io/linuxserver/webtop:ubuntu-xfce

ARG TARGETARCH=amd64
RUN test "$TARGETARCH" = "amd64" || (echo "This project targets linux/amd64; received $TARGETARCH" >&2 && exit 1)

LABEL maintainer="you"
LABEL description="Claude Desktop optimized for mobile - rapid response remote desktop for Android"

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
        jq \
        git \
        build-essential \
        python3 \
        python3-pip && \
    rm -rf /var/lib/apt/lists/*

# ---- Node.js 20 (Claude Code requires it) ----
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    npm install -g @anthropic-ai/claude-code && \
    rm -rf /var/lib/apt/lists/*

# ---- Claude Desktop (official Anthropic apt repo) ----
RUN curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc \
      https://downloads.claude.ai/claude-desktop/key.asc && \
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" \
      > /etc/apt/sources.list.d/claude-desktop.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends claude-desktop && \
    rm -rf /var/lib/apt/lists/*

# ---- Performance optimization for Claude Desktop on mobile ----
COPY bin/claude-mobile-perf.sh /usr/local/bin/claude-mobile-perf.sh
COPY bin/android-perf.sh /usr/local/bin/android-perf.sh
COPY autostart/claude-mobile-perf.desktop /etc/xdg/autostart/claude-mobile-perf.desktop
COPY autostart/android-perf.desktop /etc/xdg/autostart/android-perf.desktop
RUN chmod +x /usr/local/bin/claude-mobile-perf.sh /usr/local/bin/android-perf.sh

# ---- Claude Desktop configuration for mobile ----
RUN mkdir -p /home/abc/.config/claude-desktop && \
    chown -R abc:abc /home/abc/.config/claude-desktop

# ---- Mobile-first defaults optimized for Claude Desktop ----
ENV PUID=1000 \
    PGID=1000 \
    TZ=Asia/Tehran \
    MAX_RES=1280x720 \
    SELKIES_ENCODER=x264enc-striped \
    SELKIES_FRAMERATE=24 \
    SELKIES_H264_CRF=30 \
    GTK_FONT_NAME="Sans 9" \
    QT_QPA_PLATFORMTHEME=gtk2

# webtop exposes:
#   3000 -> HTTP
#   3001 -> HTTPS (recommended)
