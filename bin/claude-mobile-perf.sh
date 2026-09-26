#!/usr/bin/env bash
# ============================================================================
# claude-mobile-perf.sh
# ============================================================================
# Advanced performance tuning specifically for Claude Desktop on mobile
# Optimizes the desktop environment for fast UI responsiveness and
# readable code display when accessed from Android devices.
#
# This script runs once per desktop session and is safe to re-run.
# ============================================================================
set -u

echo "[claude-mobile] Starting Claude Desktop mobile optimization..."

# ---- 1. XFCE Compositing & Animations ----
echo "[claude-mobile] Disabling XFCE compositing and animations..."
if command -v xfconf-query >/dev/null 2>&1; then
  # Disable compositing (biggest single performance gain)
  xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s false 2>/dev/null || true
  
  # Disable animation previews and transitions
  xfconf-query -c xfwm4 -p /general/cycle_preview -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/zoom_desktop -t bool -s false 2>/dev/null || true
  
  # Disable window shadows (reduces streaming overhead)
  xfconf-query -c xfwm4 -p /general/show_dock_shadow -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/show_frame_shadow -t bool -s false 2>/dev/null || true
  xfconf-query -c xfwm4 -p /general/show_popup_shadow -t bool -s false 2>/dev/null || true
  
  # Solid color background (no wallpaper scaling overhead)
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -t int -s 0 2>/dev/null || true
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/color-style -t int -s 0 2>/dev/null || true
  # Dark background reduces streaming bandwidth
  xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/rgba1 -t double -t double -t double -t double -s 0.15 -s 0.15 -s 0.15 -s 1.0 2>/dev/null || true
  
  # Disable panel animations
  xfconf-query -c xfce4-panel -p /panels/panel-1/autohide-behavior -t int -s 0 2>/dev/null || true
  
  # Optimize font rendering for readability
  xfconf-query -c xfce4-desktop -p /desktop-icons/font-size -t int -s 10 2>/dev/null || true
fi

# ---- 2. Kill Background Compositors ----
echo "[claude-mobile] Removing background compositors..."
for proc in picom compton xcompmgr; do
  if command -v pkill >/dev/null 2>&1; then
    pkill -x "$proc" 2>/dev/null || true
  fi
done

# ---- 3. Disable Screensaver & Power Management ----
echo "[claude-mobile] Disabling screensaver and power management..."
if command -v xset >/dev/null 2>&1 && [ -n "${DISPLAY:-}" ]; then
  xset s off 2>/dev/null || true
  xset -dpms 2>/dev/null || true
  xset s noblank 2>/dev/null || true
fi

# ---- 4. GTK & Qt Rendering Optimization ----
echo "[claude-mobile] Optimizing GTK/Qt rendering..."
export GTK_ANIMATION=none
export GDK_RENDERING=image
export GDK_SCALE=1
export QT_QUICK_BACKEND=software
export QT_QPA_PLATFORMTHEME=gtk2
export QT_AUTO_SCREEN_SCALE_FACTOR=0

# ---- 5. Font Antialiasing for Code Readability ----
echo "[claude-mobile] Configuring fonts for code readability..."
if command -v xfconf-query >/dev/null 2>&1; then
  # Enable font hinting for clearer text
  xfconf-query -c xfce4-appearance -p /FontAntiAlias -t int -s 1 2>/dev/null || true
  # Set monospace font for terminal/code
  xfconf-query -c xfce4-appearance -p /FontName -t string -s "Monospace 9" 2>/dev/null || true
fi

# ---- 6. Mouse/Trackpad Configuration ----
echo "[claude-mobile] Configuring trackpad for mobile touch..."
if command -v xinput >/dev/null 2>&1; then
  # Disable acceleration for predictable touch response
  for device in $(xinput list --id-only 2>/dev/null); do
    xinput set-prop "$device" "Accel Speed" 0 2>/dev/null || true
  done
fi

# ---- 7. Reduce CPU Throttling ----
echo "[claude-mobile] Optimizing CPU performance..."
if [ -w /sys/devices/system/cpu ]; then
  for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null; do
    echo "performance" > "$cpu" 2>/dev/null || true
  done
fi

# ---- 8. Terminal & Text Editor Optimization ----
echo "[claude-mobile] Optimizing terminal for Claude Code..."
export TERM=xterm-256color
export EDITOR=nano

echo "[claude-mobile] ✓ Claude Desktop mobile optimization complete!"
echo "[claude-mobile] Claude Desktop should now be fast and responsive on your mobile device."
echo "[claude-mobile] For best experience: Use Trackpad Mode and Fullscreen."

exit 0
