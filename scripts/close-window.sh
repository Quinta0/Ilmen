#!/usr/bin/env bash
# Close window - tries QS first (for confirm dialog), falls back to niri

if ! pgrep -f "qs -c ii" >/dev/null 2>&1; then
    niri msg action close-window
    exit 0
fi

if timeout 0.2 qs -c ii ipc call closeConfirm trigger 2>/dev/null; then
    exit 0
fi

niri msg action close-window
