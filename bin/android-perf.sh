#!/usr/bin/env bash
set -u

echo "[android-perf] Starting Android performance optimization..."

if command -v xfconf-query >/dev/null 2>&1; then
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

for proc in picom compton xcompmgr; do
  if command -v pkill >/dev/null 2>&1; then
    pkill -x "$proc" 2>/dev/null || true
  fi
done

if command -v xset >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  xset s off 2>/dev/null || true
  xset -dpms 2>/dev/null || true
  xset s noblank 2>/dev/null || true
fi

export GTK_ANIMATION=none
export GDK_RENDERING=image
export QT_QUICK_BACKEND=software

echo "[android-perf] ✓ Android performance optimization complete!"

exit 0
