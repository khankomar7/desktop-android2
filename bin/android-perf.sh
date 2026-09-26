#!/usr/bin/env bash
set -u

echo "[android-perf] Starting Android performance optimization..."

# Android-first performance: disable compositing and animation overhead
# This helps with low-latency mobile streaming

if command -v xfconf-query >/dev/null 2>&1; then
  echo "[android-perf] Disabling XFCE compositing and animations..."
  xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/cycle_preview -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/show_dock_shadow -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/show_frame_shadow -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/show_popup_shadow -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/zoom_desktop -t bool -s false 2>/dev/null || true

  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -t int -s 0 2>/dev/null || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/color-style -t int -s 0 2>/dev/null || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/rgba1 -t double -t double -t double -t double -s 0.10 -s 0.12 -s 0.16 -s 1.0 2>/dev/null || true

  xfconf-query -c xfce4-panel -p /panels/panel-1/autohide-behavior -t int -s 0 2>/dev/null || true
fi

echo "[android-perf] Removing background compositors..."
for proc in picom compton xcompmgr; do
  if command -v pkill >/dev/null 2>&1; then
    pkill -x "$proc" 2>/dev/null || true
  fi
done

echo "[android-perf] Disabling screensaver and DPMS..."
if command -v xset >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  xset s off 2>/dev/null || true
  xset -dpms 2>/dev/null || true
  xset s noblank 2>/dev/null || true
fi

echo "[android-perf] Setting GTK/Qt environment variables..."
export GTK_ANIMATION=none
export GDK_RENDERING=image
export QT_QUICK_BACKEND=software
export QT_QPA_PLATFORMTHEME=gtk2

echo "[android-perf] ✓ Android performance optimization complete!"
echo "[android-perf] Desktop should now feel responsive on mobile browsers."

exit 0
