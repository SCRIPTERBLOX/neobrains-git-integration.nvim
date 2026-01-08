local buffer = require("neobrains-git-integration.buffer")

local M = {}

function M.create(user_config)
	local cfg = vim.tbl_deep_extend("force", require("neobrains-git-integration.config").default_config, user_config or {})

	local buf = buffer.create(cfg)

	return buf
end

return M
