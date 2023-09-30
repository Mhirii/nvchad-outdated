local config = require("plugins.configs.lspconfig")
local on_attach = config.on_attach
local capabilities = config.capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
  }
  vim.lsp.buf.execute_command(params)
end

lspconfig.tsserver.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    preferences = {
      disableSuggestions = true,
    }
  },
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports"
    }
  }
}

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

-- default config
local servers = {
  "html",
  "cssls",
  "tsserver",
  "clangd",
  "eslint",
  "astro",
  "gopls",
  "grammarly",
  "emmet_ls",
  "yamlls",
  "jsonls",
  "dockerls",
  "lua_ls",
  "biome",
}


require("mason-lspconfig").setup {
  ensure_installed = servers,
}

local custom_on_attach = function(client, bufnr)
  on_attach(client, bufnr)

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint(bufnr, true)
  end
end



lspconfig.biome.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = {
      'javascript',
      'javascriptreact',
      'json',
      'jsonc',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
    },
    root_dir = function(fname)
      return util.find_package_json_ancestor(fname)
        or util.find_node_modules_ancestor(fname)
        or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  docs = {
    description = [[
        https://biomejs.dev
       
        Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).
      
        ```sh
        npm install [-g] @biomejs/biome
        ```
      ]],
    default_config = {
      root_dir = [[root_pattern('package.json', 'node_modules', '.git', 'biome.json')]],
    },
  },
}


