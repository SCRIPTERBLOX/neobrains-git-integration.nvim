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

	-- Store state for restoration
	state.original_buf = original_buf
	state.git_buf = buf
	state.win = win

	-- Switch to git buffer in the same window
	vim.api.nvim_win_set_buf(win, buf)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "filetype", "git-integration")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")

	-- Set up autocmd to restore original buffer when git buffer is closed
	vim.api.nvim_create_autocmd({"BufWipeout", "BufDelete"}, {
		buffer = buf,
		once = true,
		callback = function()
			buffer.restore_original()
		end,
	})

	return buf
end

function buffer.restore_original()
	if not state.original_buf then
		print("No original buffer stored")
		return
	end
	
	if not state.win then
		print("No window stored")
		return
	end
	
	if not vim.api.nvim_win_is_valid(state.win) then
		print("Window is invalid")
		state.original_buf = nil
		state.git_buf = nil
		state.win = nil
		return
	end
	
	-- Check if original buffer is still valid
	if not vim.api.nvim_buf_is_valid(state.original_buf) then
		print("Original buffer is invalid, focusing NvimTree")
		-- If original buffer is invalid, try to focus NvimTree to recreate it
		pcall(vim.cmd, "NvimTreeFocus")
		state.original_buf = nil
		state.git_buf = nil
		state.win = nil
		return
	end
	
	-- Restore the original NvimTree buffer to the same window
	local success, err = pcall(vim.api.nvim_win_set_buf, state.win, state.original_buf)
	if not success then
		print("Failed to set buffer: " .. err)
	else
		print("Successfully restored original buffer")
	end
	
	-- Clear state
	state.original_buf = nil
	state.git_buf = nil
	state.win = nil
end

function buffer.close()
	if state.git_buf and vim.api.nvim_buf_is_valid(state.git_buf) then
		vim.api.nvim_buf_delete(state.git_buf, {force = true})
	end
end

return buffer
