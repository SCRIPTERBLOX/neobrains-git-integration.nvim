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

	-- Open NvimTree first to ensure it's available
	vim.cmd("NvimTreeOpen")
	vim.cmd("NvimTreeFocus")
	
	-- Get the current window (should be NvimTree window)
	local win = vim.api.nvim_get_current_win()
	
	-- Store window info for restoration
	state.win = win
	state.git_buf = buf

	-- Set up buffer content
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "filetype", "git-integration")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

	-- Replace the buffer in the NvimTree window
	vim.api.nvim_win_set_buf(win, buf)

	return buf
end

function buffer.restore_original()
	-- Close the current window and let NvimTree recreate itself
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
	end

	vim.cmd("wincmd r")
	
	-- Reopen NvimTree
	vim.cmd("NvimTreeOpen")
	vim.cmd("NvimTreeFocus")
	
	-- Clear state
	state.original_buf_name = nil
	state.git_buf = nil
	state.win = nil

	vim.cmd("wincmd r")
end

function buffer.close()
	if state.git_buf and vim.api.nvim_buf_is_valid(state.git_buf) then
		vim.api.nvim_buf_delete(state.git_buf, {force = true})
	end
end

return buffer
