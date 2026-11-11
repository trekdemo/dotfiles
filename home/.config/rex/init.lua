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

-- ---------------------------------------------------------------------
-- Actions
-- ---------------------------------------------------------------------

-- Bounds { x, y, width, height } for a layer centred in the window.
-- `size` is a fraction of the window: one number for both sides, or
-- { width, height }.
local function centred_bounds(size)
	local w, h = size, size
	if type(size) == "table" then
		w, h = size[1], size[2]
	end
	return { (1 - w) / 2, (1 - h) / 2, w, h }
end

-- Register action `name` that runs a program in a floating pane, in the
-- focused pane's directory. The shell doesn't report its directory (OSC 7),
-- so the terminal's `pwd` is empty; take the foreground process's cwd instead.
--
-- opts (all optional):
--   command  program to run, a string or an argv table (default: `name`)
--   label    pane label (default: `name`)
--   size     fraction of the window, number or { width, height } (default: 0.9)
local function floating_action(name, title, opts)
	opts = opts or {}
	local command = opts.command or name
	if type(command) == "string" then
		command = { command }
	end
	local bounds = centred_bounds(opts.size or 0.9)

	rex.action({
		name = name,
		title = title,
		run = function(ctx)
			local process = rex.block.call(terminal, "process", { block_id = ctx.block_id })
			local cwd = process.foreground and process.foreground.cwd or ""

			rex.session.new_layer({
				session_id = ctx.session_id,
				bounds = bounds,
				layout = {
					block = {
						flavor = "com.superlogical.terminal.shell",
						label = opts.label or name,
						options = { command = command, cwd = cwd },
					},
				},
				focus = true,
			})
		end,
	})
end

floating_action("lazygit", "Open lazygit")
floating_action("lazydocker", "Open lazydocker")
floating_action("yazi", "Open yazi")
floating_action("gh_dash", "Open gh dash", { command = { "gh", "dash" } })

-- Pick a JANE Code task and open it in the browser (script: bin/jane-tasks).
floating_action("jane_tasks", "Open JANE tasks", {
	command = os.getenv("HOME") .. "/.config/rex/bin/jane-tasks",
	label = "JANE tasks",
	size = { 0.5, 0.8 },
})

rex.bind("ctrl+a>g", "lazygit")
rex.bind("ctrl+a>d", "lazydocker")
rex.bind("ctrl+a>y", "yazi")
rex.bind("ctrl+a>p", "gh_dash")
rex.bind("ctrl+a>j", "jane_tasks")
