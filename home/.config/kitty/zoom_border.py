#!/usr/bin/env python3
# Toggle the "zoom" (stack) layout and draw a subtle border around the zoomed
# pane so it's obvious you're in the fullscreen layout while other panes exist.
#
# The stack layout has needs_window_borders = False, so kitty normally draws no
# border around the single visible window. We work around this by:
#   * setting must_draw_borders on the stack layout instance (reserves the
#     border space around the single visible window), and
#   * enabling draw_window_borders_for_single_window, which makes kitty draw a
#     full border (rather than minimal separators) whenever one group is visible
#     -- always the case in the stack layout.
# Both are reverted when leaving the zoom, so ordinary layouts are untouched.
#
# While zoomed we also add ~2 character widths of extra margin around the pane
# (outside the border).
#
# The border uses the theme's active_border_color (a subtle Catppuccin lavender).

from kittens.tui.handler import result_handler

# Extra margin (outside the border) while zoomed, in character widths (cells).
ZOOM_MARGIN_CELLS = 2


def main(args):
    pass


def _cell_width_pt(window):
    from kitty.fast_data_types import get_os_window_size

    os_win = get_os_window_size(window.os_window_id)
    if not os_win:
        return None
    return os_win['cell_width'] / os_win['xscale']


def _set_margin(boss, tab, value):
    for window in tab.windows:
        boss.call_remote_control(window, ('set-spacing', value))


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    from kitty.fast_data_types import get_options

    tab = boss.active_tab
    if tab is None:
        return

    opts = get_options()

    if tab.current_layout.name == 'stack':
        # Leaving zoom: restore the previous layout, border and padding.
        prev_layout = getattr(tab, '_zoom_prev_layout', None) or 'tall'
        prev_single_border = getattr(tab, '_zoom_prev_single_border', False)
        tab.goto_layout(prev_layout)
        opts.draw_window_borders_for_single_window = prev_single_border
        _set_margin(boss, tab, 'margin=default')
        tab._zoom_prev_layout = None
    else:
        # Entering zoom: remember state, switch to stack, force the border.
        tab._zoom_prev_layout = tab.current_layout.name
        tab._zoom_prev_single_border = opts.draw_window_borders_for_single_window
        tab.goto_layout('stack')
        tab.current_layout.must_draw_borders = True
        opts.draw_window_borders_for_single_window = True

        active = boss.active_window
        cell_w = _cell_width_pt(active) if active is not None else None
        if cell_w:
            margin = round(ZOOM_MARGIN_CELLS * cell_w)
            _set_margin(boss, tab, f'margin={margin}')

    tab.relayout_borders()
    tab.relayout()
