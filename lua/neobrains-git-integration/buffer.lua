local buffer = {}

-- Store state for buffer management
local state = {
	original_buf = nil,
	git_buf = nil,
	win = nil,
}

function buffer.create(cfg)
	local buf = vim.api.nvim_create_buf(false, true)

	local lines = {
		"Starting",
		"Git",
		"Integration"
	}

	-- Focus NvimTree and get current state
	vim.cmd(":NvimTreeFocus")
	local win = vim.api.nvim_get_current_win()
	local original_buf = vim.api.nvim_win_get_buf(win)

	-- Store the original buffer name for restoration
	local original_buf_name = vim.api.nvim_buf_get_name(original_buf)
	state.original_buf_name = original_buf_name
	state.git_buf = buf
	state.win = win

	-- Set up buffer content first
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "filetype", "git-integration")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

	-- Switch to git buffer using :buffer command to preserve original buffer
	vim.cmd("buffer " .. buf)

	-- No autocmd - let user manually restore when needed

	return buf
end

function buffer.restore_original()
	-- Simply focus NvimTree - it will handle recreating its buffer if needed
	vim.cmd("NvimTreeFocus")
	
	-- Clear state
	state.original_buf_name = nil
	state.git_buf = nil
	state.win = nil
end

function buffer.close()
	if state.git_buf and vim.api.nvim_buf_is_valid(state.git_buf) then
		vim.api.nvim_buf_delete(state.git_buf, {force = true})
	end
end

return buffer
