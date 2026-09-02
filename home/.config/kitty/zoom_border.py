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
# The border uses the theme's active_border_color (a subtle Catppuccin lavender).

from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    from kitty.fast_data_types import get_options

    tab = boss.active_tab
    if tab is None:
        return

    opts = get_options()

    if tab.current_layout.name == 'stack':
        # Leaving zoom: restore the previous layout and border behaviour.
        prev_layout = getattr(tab, '_zoom_prev_layout', None) or 'tall'
        prev_single_border = getattr(tab, '_zoom_prev_single_border', False)
        tab.goto_layout(prev_layout)
        opts.draw_window_borders_for_single_window = prev_single_border
        tab._zoom_prev_layout = None
    else:
        # Entering zoom: remember state, switch to stack, force the border.
        tab._zoom_prev_layout = tab.current_layout.name
        tab._zoom_prev_single_border = opts.draw_window_borders_for_single_window
        tab.goto_layout('stack')
        tab.current_layout.must_draw_borders = True
        opts.draw_window_borders_for_single_window = True

    tab.relayout_borders()
    tab.relayout()
