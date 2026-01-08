local buffer = {}

function buffer.create(cfg, win)
	local buf = vim.api.nvim_create_buf(false, true)

	local lines = {
		"Starting",
		"Git",
		"Integration"
	}

	vim.api.nvim_win_set_buf(win, buf)
	vim.apo.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "filetype", "git-integration")
	vim.api.nvim_set_option(buf, "buftype", "nofile")

	return buf
end

return buffer
