---
name: kitty
description: |
  Kitty terminal remote control — create, read, write, split, resize, and manage terminal panes/tabs/windows via `kitty @` commands. Use for multi-pane workflows, live preview, and terminal orchestration.

  <example>
  Context: User wants a new split pane
  user: "open a new pane to the right"
  </example>

  <example>
  Context: User wants to send text to another pane
  user: "run npm test in the other pane"
  </example>

  <example>
  Context: User wants to see what's in a pane
  user: "what's showing in pane 9?"
  </example>
---

# Kitty Remote Control

Control the Kitty terminal multiplexer via `kitty @` commands. Create splits, tabs, windows — read from and write to any pane.

## Discovery

```bash
# List all windows/panes with IDs, PIDs, titles, dimensions
kitty @ ls | python3 -c "
import sys, json
for w in json.load(sys.stdin):
  for tab in w.get('tabs', []):
    for win in tab.get('windows', []):
      print(f\"id:{win['id']}  pid:{win.get('pid','-')}  title:{win.get('title','')[:50]}  {win.get('columns','?')}x{win.get('lines','?')}  focused:{win.get('is_focused',False)}\")
"
```

## Matching

All commands use `--match` (or `-m`) to target a pane. Match syntax:

| Field | Example | Notes |
|-------|---------|-------|
| `id:9` | Exact window ID | Most reliable |
| `title:visor` | Regex on title | |
| `pid:1234` | Process ID | |
| `cwd:/Projects/tengu` | Working directory | |
| `state:focused` | Focus state | |
| `recent:0` | Most recent (0=active) | |

Combine with `and`, `or`, `not`: `--match "title:visor and not id:1"`

## Read Pane Content

```bash
# Get all text from a pane
kitty @ get-text --match id:9

# Get only the visible screen (no scrollback)
kitty @ get-text --match id:9 --extent screen

# Get selected text
kitty @ get-text --match id:9 --extent selection
```

## Write to Pane

```bash
# Send a command (include \r for Enter)
kitty @ send-text --match id:9 'echo hello\r'

# Send raw text (no Enter)
kitty @ send-text --match id:9 'some text'

# Send keystrokes
kitty @ send-key --match id:9 ctrl+c
kitty @ send-key --match id:9 escape
```

## Create Panes (Splits)

```bash
# Horizontal split (new pane below)
kitty @ launch --location hsplit

# Vertical split (new pane to the right)
kitty @ launch --location vsplit

# Split next to a specific pane
kitty @ launch --location vsplit --next-to id:9

# Split with a command running
kitty @ launch --location hsplit htop

# Split with a title
kitty @ launch --location vsplit --title "Preview"

# Split with a specific working directory
kitty @ launch --location vsplit --cwd /Users/chi/Projects/marauder-os

# Auto split (kitty decides orientation)
kitty @ launch --location split
```

## Create Tabs

```bash
# New tab with shell
kitty @ launch --type tab

# New tab with title and command
kitty @ launch --type tab --tab-title "Tests" cargo test

# New tab next to current (not at end)
kitty @ launch --type tab --location after
```

## Create OS Windows

```bash
# New OS-level window
kitty @ launch --type os-window

# New OS window with title
kitty @ launch --type os-window --os-window-title "Debug"
```

## Focus

```bash
# Focus a window/pane by ID
kitty @ focus-window --match id:9

# Focus a tab
kitty @ focus-tab --match title:Tests
```

## Resize

```bash
# Resize pane (increment in cells)
kitty @ resize-window --match id:9 --increment 5 --axis horizontal
kitty @ resize-window --match id:9 --increment 5 --axis vertical

# Reset layout
kitty @ resize-window --match id:9 --axis reset
```

## Close

```bash
# Close a specific pane
kitty @ close-window --match id:9

# Close a tab (and all panes in it)
kitty @ close-tab --match title:Tests
```

## Overlays

```bash
# Overlay covering active window (disappears when done)
kitty @ launch --type overlay less /tmp/log.txt

# Persistent overlay (treated as main window)
kitty @ launch --type overlay-main bash
```

## Markers (Highlighting)

```bash
# Highlight text matching a regex
kitty @ create-marker --match id:9 text 1 "ERROR"

# Remove markers
kitty @ remove-marker --match id:9
```

## Common Patterns

### Run a command in a new split and watch output
```bash
ID=$(kitty @ launch --location vsplit --title "Test Runner" cargo test)
# Later, read its output:
kitty @ get-text --match id:$ID
```

### Side-by-side preview
```bash
kitty @ launch --location vsplit --title "Preview" --cwd /tmp
kitty @ send-text --match title:Preview 'watch -n1 cat output.txt\r'
```

### Clear and write fresh content
```bash
kitty @ send-text --match id:9 'clear\r'
sleep 0.2
kitty @ send-text --match id:9 'echo "fresh content"\r'
```

## Notes

- All `kitty @` commands require `allow_remote_control` in kitty.conf
- Window IDs are stable for the session lifetime — use them over titles for reliability
- `launch` returns the new window ID on stdout — capture it for later reference
- `send-text` with `\r` simulates pressing Enter
- For sending special keys use `send-key` instead of `send-text`
