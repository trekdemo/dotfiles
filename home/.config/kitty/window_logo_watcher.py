"""Kitty window watcher that sets the window logo based on the running process."""

import os
import sys


def _log(msg):
    print(f"[window_logo_watcher] {msg}", file=sys.stderr, flush=True)

# Map command names to logo image paths.
# Place your logo PNGs in ~/.config/kitty/logos/
LOGO_DIR = os.path.expanduser("~/.config/kitty/logos")

COMMAND_LOGOS = {
    "claude": "claude.png",
    "nvim": "neovim.png",
    "lazygit": "git.png",
}


def on_load(boss, data):
    _log("Watcher loaded successfully")


def _resolve_command(cmdline):
    """Extract the base command name from a command line string."""
    if not cmdline:
        return None
    parts = cmdline.strip().split()
    if not parts:
        return None
    return os.path.basename(parts[0])


def _set_logo(boss, window, logo_path=None):
    """Set or clear the window logo via remote control."""
    path = logo_path or "none"
    boss.call_remote_control(window, ("set-window-logo", f"--self", path))


def on_cmd_startstop(boss, window, data):
    """Called when a shell command starts or stops."""
    _log(f"on_cmd_startstop: {data}")
    if data["is_start"]:
        cmd = _resolve_command(data.get("cmdline"))
        if cmd and cmd in COMMAND_LOGOS:
            logo = os.path.join(LOGO_DIR, COMMAND_LOGOS[cmd])
            _log(f"Matched cmd={cmd!r}, logo={logo}, exists={os.path.isfile(logo)}")
            if os.path.isfile(logo):
                _set_logo(boss, window, logo)
    else:
        # Command ended — clear the logo
        _set_logo(boss, window)
