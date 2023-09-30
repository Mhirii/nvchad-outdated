---@type ChadrcConfig
local M = {}

local core = require "custom.utils.core"

local highlights = require "custom.highlights"

M.ui = { 
  theme = 'tokyonight',

  cmp = {
    icons = true,
    lspkind_text = true,
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = { style = "bordered" },

  extended_integrations = {
    "dap",
    "hop",
    "rainbowdelimiters",
    "codeactionmenu",
    "todo",
    "trouble",
    "notify",
  },

  hl_override = highlights.override,
  hl_add = highlights.add,

  nvdash = core.nvdash,

}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
