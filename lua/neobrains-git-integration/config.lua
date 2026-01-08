local feats = require("neobrains-git-integration.feats")

local config = {}

config.default_config = {
  width = 5,
  valign = "top",
  margin = 1,
  feats = {
    "add",
    "commit",
    "push",
    "remotes"
  }
}

return config
