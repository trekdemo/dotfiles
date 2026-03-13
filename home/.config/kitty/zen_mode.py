from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    tab = boss.active_tab
    if tab is None:
        return

    state = getattr(boss, '_zen_mode_state', None)

    if state is not None:
        _exit_zen(boss, tab, state)
    else:
        _enter_zen(boss, tab)


def _enter_zen(boss, tab):
    from kitty.fast_data_types import current_fonts, get_os_window_size

    w = boss.active_window
    if w is None:
        return

    font_size = current_fonts()['font_sz_in_pts']
    os_win = get_os_window_size(w.os_window_id)
    cell_w = os_win['cell_width'] / os_win['xscale']
    os_width = os_win['width']

    boss._zen_mode_state = {
        'layout': tab.current_layout.name,
    }

    tab.goto_layout('stack')

    # +2pt font — estimate new cell width proportionally
    new_font_size = font_size + 2.0
    new_cell_w = cell_w * new_font_size / font_size
    target_cols = 100
    padding_h = max(0, int((os_width - target_cols * new_cell_w) / 2))

    boss.call_remote_control(None, ('set-font-size', str(new_font_size)))
    boss.call_remote_control(None, ('set-spacing', f'padding-h={padding_h}', 'padding-v=40'))


def _exit_zen(boss, tab, state):
    tab.goto_layout(state['layout'])
    boss.call_remote_control(None, ('set-font-size', '0'))
    boss.call_remote_control(None, ('set-spacing', 'padding=default'))
    boss._zen_mode_state = None
