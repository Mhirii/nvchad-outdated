local overrides = require "custom.configs.overrides"
local cmp_opt = require "custom.configs.cmp"

local plugins = {

  { "BrunoKrugel/nvcommunity" },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
      "williamboman/mason-lspconfig.nvim",
    },
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  {
    "williamboman/mason.nvim",
    opts={
      ensure_installed = {
        -- typescript
        "typescript-language-server",
        -- "eslint-lsp",
        -- "eslint_d",
        "biome",
        "prettier",
        "js-debug-adapter",

        -- go
        "gopls",
      }
    }
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = overrides.telescope,
    dependencies = {
      "debugloop/telescope-undo.nvim",
      "gnfisher/nvim-telescope-ctags-plus",
      "tom-anders/telescope-vim-bookmarks.nvim",
      "benfowler/telescope-luasnip.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "Marskey/telescope-sg",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "kkharji/sqlite.lua" },
      },
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = overrides.blankline,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      -- "windwp/nvim-ts-autotag",
      {
        "windwp/nvim-ts-autotag",
        opts = { enable_close_on_slash = false },
      },
      -- "chrisgrieser/nvim-various-textobjs",
      "filNaj/tree-setter",
      -- "echasnovski/mini.ai",
      "piersolenski/telescope-import.nvim", --ts lua python
      -- "LiadOz/nvim-dap-repl-highlights",
      "RRethy/nvim-treesitter-textsubjects",
      "kevinhwang91/promise-async",
      {
        "kevinhwang91/nvim-ufo",
        config = function()
          require "custom.configs.ufo"
        end,
      },
      {
        "Jxstxs/conceal.nvim",
        config = function()
          local conceal = require "conceal"
          conceal.setup {
            ["lua"] = {
              enabled = false,
            },
          }
          conceal.generate_conceals()
        end,
      },
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
          require("Comment").setup {
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
          }
        end,
      },
    },
    opts = overrides.treesitter,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = cmp_opt.cmp,
    dependencies = {
      "delphinus/cmp-ctags",
      "hrsh7th/cmp-nvim-lsp-document-symbol", -- /@ search symbols
      "ray-x/cmp-treesitter", -- cmp from treesitter highlights
      "tzachar/cmp-fuzzy-buffer", --fuzzy completions
      "roobert/tailwindcss-colorizer-cmp.nvim",
      "tzachar/fuzzy.nvim",
      "rcarriga/cmp-dap",
      "js-everts/cmp-tailwind-colors",
      { "jcdickinson/codeium.nvim", config = true },
      -- {
      --   "tzachar/cmp-tabnine",
      --   build = "./install.sh",
      --   config = function()
      --     local tabnine = require "cmp_tabnine.config"
      --     tabnine:setup {
      --       max_lines = 1000,
      --       max_num_results = 3,
      --       sort = true,
      --       show_prediction_strength = false,
      --       run_on_every_keystroke = true,
      --       snipper_placeholder = "..",
      --       ignored_file_types = {},
      --     }
      --   end,
      -- },
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
          require "custom.configs.luasnip"
          require "custom.configs.autotag"
        end,
      },
      {
        "windwp/nvim-autopairs",
        config = function()
          require "custom.configs.autopair"
        end,
      },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "cmp")
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        if item.kind == "Color" then
          item.kind = "⬤"
          format_kinds(entry, item)
          return require("tailwindcss-colorizer-cmp").formatter(entry, item)
        end
        return format_kinds(entry, item)
      end
      local cmp = require "cmp"

      cmp.setup(opts)

      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = opts.mapping,
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    -- enabled = false,
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },

    {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      require("dapui").setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },

  {
    "mfussenegger/nvim-dap",
    config = function()
      require "custom.configs.dap"
      require("core.utils").load_mappings("dap")
    end
  },

  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },

 {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },

  -- LSP 
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require "custom.configs.lspsaga"
    end,
  },

  -- Quality of Life
 {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },

  {
    "simrat39/symbols-outline.nvim",
    lazy=false,
    opts = function ()
      return require "custom.configs.symbols"
    end,
    config = function(_, opts)
      require("symbols-outline").setup(opts)
      require("core.utils").load_mappings("symbols_outline")
    end
  },

  {
    "code-biscuits/nvim-biscuits",
    event = "LspAttach",
    config = function()
      require "custom.configs.biscuits"
    end,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    event = "BufRead",
    config = function()
      require "custom.configs.refactoring"
    end,
  },

  {
    "nguyenvukhang/nvim-toggler",
    event = "BufReadPost",
    config = function()
      require("nvim-toggler").setup {
        remove_default_keybinds = true,
      }
    end,
  },

  {
    "phaazon/hop.nvim",
    event = "BufReadPost",
    branch = "v2",
    config = function()
      require "custom.configs.hop"
    end,
  },


  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = {},
  },


}

return plugins
