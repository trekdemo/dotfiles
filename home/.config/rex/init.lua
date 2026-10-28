-- Rex config: https://www.superlogical.com/rex/docs/customize/config
-- Reload with `rex config reload`; validate with `rex config check`.

-- `rex` is a global Rex provides at load time; lua_ls doesn't know it.
---@diagnostic disable: undefined-global

-- ---------------------------------------------------------------------
-- Keybindings (ported from Ghostty)
-- ---------------------------------------------------------------------
rex.bind("alt+enter", "pane.zoom")

-- Move between panes with opt+hjkl. When there is no pane in that direction,
-- the key goes to the terminal instead (returning false hands it over
-- unchanged), like Ghostty's `performable:` bindings.
--
-- Inside Neovim, smart-splits.nvim owns <A-hjkl>. Rex has no option-as-alt
-- setting, so a passed-through key arrives as `˙` etc.; write the Meta
-- sequence (ESC + key) ourselves, as Ghostty's `esc:h` did.
local terminal = "com.superlogical.terminal"
local directions = { h = "left", j = "down", k = "up", l = "right" }

for key, direction in pairs(directions) do
	rex.bind("alt+" .. key, function(ctx)
		local process = rex.block.call(terminal, "process", { block_id = ctx.block_id })
		if process.foreground and process.foreground.name == "nvim" then
			rex.block.call(terminal, "write", { block_id = ctx.block_id, data = "\27" .. key })
			return true
		end

		-- focus_direction succeeds without bumping the revision when nothing lies that way.
		local before = rex.session.view({ session_id = ctx.session_id }).revision
		local after = rex.session.focus_direction({ session_id = ctx.session_id, direction = direction }).revision
		return after ~= before
	end)
end

-- Run `program` in a floating pane, in the focused pane's directory.
-- The shell doesn't report its directory (OSC 7), so the terminal's `pwd`
-- is empty; take the foreground process's cwd instead.
local function open_floating(program)
	return function(ctx)
		local process = rex.block.call(terminal, "process", { block_id = ctx.block_id })
		local cwd = process.foreground and process.foreground.cwd or ""

		rex.session.new_layer({
			session_id = ctx.session_id,
			bounds = { 0.05, 0.05, 0.9, 0.9 },
			layout = {
				block = {
					flavor = "com.superlogical.terminal.shell",
					label = program,
					options = { command = { program }, cwd = cwd },
				},
			},
			focus = true,
		})
		return true
	end
end

rex.bind("ctrl+a>g", open_floating("lazygit"))
rex.bind("ctrl+a>d", open_floating("lazydocker"))
