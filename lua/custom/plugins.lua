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
    "AckslD/muren.nvim",
    cmd = "MurenToggle",
    config = true,
  },

  {
    "m4xshen/hardtime.nvim",
    cmd = { "Hardtime" },
    opts = {},
  },


  {
    "kevinhwang91/nvim-fundo",
    event = "BufReadPost",
    opts = {},
    build = function()
      require("fundo").install()
    end,
  },

  {
    "lvimuser/lsp-inlayhints.nvim",
    branch = "anticonceal",
    event = "LspAttach",
    config = function()
      require "custom.configs.inlayhints"
    end,
  },

  {
    "VonHeikemen/searchbox.nvim",
    cmd = { "SearchBoxMatchAll", "SearchBoxReplace", "SearchBoxIncSearch" },
    config = true,
  },

  {
    "utilyre/sentiment.nvim",
    event = "LspAttach",
    opts = {},
    init = function()
      vim.g.loaded_matchparen = 1
    end,
  },

  {
    "0xAdk/full_visual_line.nvim",
    keys = { "V" },
    config = function()
      require("full_visual_line").setup {}
    end,
  },

  {
    "FeiyouG/command_center.nvim",
    event = "VeryLazy",
    config = function()
      require "custom.configs.command"
    end,
  },

  {
    "kevinhwang91/nvim-hlslens",
    event = "BufReadPost",
    config = function()
      require("scrollbar.handlers.search").setup {
        {
          nearest_float_when = false,
          override_lens = function(render, posList, nearest, idx, relIdx)
            local sfw = vim.v.searchforward == 1
            local indicator, text, chunks
            local absRelIdx = math.abs(relIdx)
            if absRelIdx > 1 then
              indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and icons.misc.up or icons.misc.down)
            elseif absRelIdx == 1 then
              indicator = sfw ~= (relIdx == 1) and icons.misc.up or icons.misc.down
            else
              indicator = icons.misc.dot
            end
            local lnum, col = unpack(posList[idx])
            if nearest then
              local cnt = #posList
              if indicator ~= "" then
                text = ("[%s %d/%d]"):format(indicator, idx, cnt)
              else
                text = ("[%d/%d]"):format(idx, cnt)
              end
              chunks = { { " ", "Ignore" }, { text, "HlSearchLensNear" } }
            else
              text = ("[%s %d]"):format(indicator, idx)
              chunks = { { " ", "Ignore" }, { text, "HlSearchLens" } }
            end
            render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
          end,
        },
      }
    end,
  },

  {
    "tzachar/highlight-undo.nvim",
    event = "BufReadPost",
    opts = {},
  },

  {
    "jghauser/fold-cycle.nvim",
    opts = {},
  },

  {
    "anuvyklack/fold-preview.nvim",
    dependencies = {
      "anuvyklack/keymap-amend.nvim",
    },
    opts = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },

  {
    "VidocqH/lsp-lens.nvim",
    event = "LspAttach",
    opts = {
      enable = false,
    },
  },

  {
    "folke/edgy.nvim",
    event = "BufReadPost",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      fix_win_height = vim.fn.has "nvim-0.10.0" == 0,
      bottom = {
        {
          ft = "toggleterm",
          size = { height = 0.2 },
        },
        { ft = "spectre_panel", size = { height = 0.4 } },
        { ft = "qf", title = "QuickFix" },
        { ft = "dapui_watches", title = "Watches" },
        { ft = "dap-repl", title = "Debug REPL" },
        { ft = "dapui_console", title = "Debug Console" },
        "Trouble",
        "Noice",
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        {
          ft = "NoiceHistory",
          title = " Log",
          open = function()
            toggle_noice()
          end,
        },
        {
          ft = "neotest-output-panel",
          title = " Test Output",
          open = function()
            vim.cmd.vsplit()
            require("neotest").output_panel.toggle()
          end,
        },
        {
          ft = "DiffviewFileHistory",
          title = " Diffs",
        },
      },
      left = {
        { ft = "undotree", title = "Undo Tree" },
        { ft = "dapui_scopes", title = "Scopes" },
        { ft = "dapui_breakpoints", title = "Breakpoints" },
        { ft = "dapui_stacks", title = "Stacks" },
        {
          ft = "diff",
          title = " Diffs",
        },

        {
          ft = "DiffviewFileHistory",
          title = " Diffs",
        },
        {
          ft = "DiffviewFiles",
          title = " Diffs",
        },
        {
          ft = "neotest-summary",
          title = "  Tests",
          open = function()
            require("neotest").summary.toggle()
          end,
        },
      },
      right = {
        "dapui_scopes",
        "sagaoutline",
        "neotest-output-panel",
        "neotest-summary",
      },
      options = {
        left = { size = 40 },
        bottom = { size = 20 },
        right = { size = 30 },
        top = { size = 10 },
      },
      wo = {
        winbar = false,
        signcolumn = "no",
      },
    },
  },

  {
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre", "SpectreOpen", "SpectreClose" },
    opts = { is_block_ui_break = true },
  },

  {
    "akinsho/toggleterm.nvim",
    keys = { [[<C-\>]] },
    cmd = { "ToggleTerm", "ToggleTermOpenAll", "ToggleTermCloseAll" },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 0.25 * vim.api.nvim_win_get_height(0)
        elseif term.direction == "vertical" then
          return 0.25 * vim.api.nvim_win_get_width(0)
        elseif term.direction == "float" then
          return 85
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_terminals = false,
      insert_mappings = true,
      start_in_insert = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      autochdir = true,
      highlights = {
        NormalFloat = {
          link = "Normal",
        },
        FloatBorder = {
          link = "FloatBorder",
        },
      },
      float_opts = {
        border = "rounded",
        winblend = 0,
      },
    },
  },

  {
    "max397574/colortils.nvim",
    cmd = "Colortils",
    config = function()
      require("colortils").setup()
    end,
  },

  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    config = function()
      require "custom.configs.glance"
    end,
  },

  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults" },
    dependencies = {
      {
        "stevearc/overseer.nvim",
        commit = "3047ede61cc1308069ad1184c0d447ebee92d749",
        opts = {
          task_list = {
            direction = "bottom",
            min_height = 25,
            max_height = 25,
            default_detail = 1,
            bindings = {
              ["q"] = function()
                vim.cmd "OverseerClose"
              end,
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("compiler").setup(opts)
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

  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gosum", "gowork" },
    dependencies = {
      {
        "ray-x/guihua.lua",
        build = "cd lua/fzy && make",
      },
    },
    config = function()
      require "custom.configs.go"
    end,
    build = ':lua require("go.install").update_all_sync()',
  },

  {
    "pmizio/typescript-tools.nvim",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    config = function()
      require "custom.configs.ts"
    end,
  },
  
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
    end,
  },

  {
    "llllvvuu/nvim-js-actions",
    keys = { "<leader>jc" },
  },

  {
    "nvim-neotest/neotest",
    event = "LspAttach",
    dependencies = {
      "nvim-neotest/neotest-go",
      "haydenmeade/neotest-jest",
    },
    config = function()
      require "custom.configs.neotest"
    end,
  },

  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    config = function()
      require("wildfire").setup()
    end,
  },

  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    opts = {
      auto_open_qflist = true,
      spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
    },
  },

  {
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    opts = {},
  },



  -- LSP 
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require "custom.configs.lspsaga"
    end,
  },

  -- ui 
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require "custom.configs.noice"
    end,
  },

  {
    "petertriho/nvim-scrollbar",
    event = "WinScrolled",
    config = function()
      require "custom.configs.scrollbar"
    end,
  },


  {
    "chikko80/error-lens.nvim",
    ft = "go",
    config = true,
  },

  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require "custom.configs.trouble"
      dofile(vim.g.base46_cache .. "trouble")
    end,
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },

  {
    "rainbowhxch/beacon.nvim",
    event = "CursorMoved",
    cond = function()
      return not vim.g.neovide
    end,
  },

  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.animate").setup {
        scroll = {
          enable = false,
        },
      }
    end,
  },

  {
    "shellRaining/hlchunk.nvim",
    event = "BufReadPost",
    config = function()
      require "custom.configs.hlchunk"
    end,
  },


  {
    "weilbith/nvim-code-action-menu",
    cmd = "CodeActionMenu",
    init = function()
      vim.g.code_action_menu_show_details = true
      vim.g.code_action_menu_show_diff = true
      vim.g.code_action_menu_show_action_kind = true
    end,
    config = function()
      dofile(vim.g.base46_cache .. "git")
      dofile(vim.g.base46_cache .. "codeactionmenu")
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {
      post_hook = function(results)
        if not results.changes then
          return
        end

        -- if more than one file is changed, save all buffers
        local filesChang = #vim.tbl_keys(results.changes)
        if filesChang > 1 then
          vim.cmd.wall()
        end

        -- FIX making the cmdline-history not navigable, pending: https://github.com/smjonas/inc-rename.nvim/issues/40
        vim.fn.histdel("cmd", "^IncRename ")
      end,
    },
  },

  {
    "luukvbaal/statuscol.nvim",
    lazy = false,
    config = function()
      require "custom.configs.statuscol"
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
    "chrisgrieser/nvim-origami",
    event = "BufReadPost",
    opts = {
      keepFoldsAcrossSessions = true,
      pauseFoldsOnSearch = true,
      setupFoldKeymaps = false,
    },
  },

  {
    "malbertzard/inline-fold.nvim",
    event = "BufReadPost",
    opts = {
      defaultPlaceholder = "…",
      queries = {
        html = {
          { pattern = 'class="([^"]*)"', placeholder = "@" }, -- classes in html
          { pattern = 'href="(.-)"' }, -- hrefs in html
          { pattern = 'src="(.-)"' }, -- HTML img src attribute
        },
        go = {
          { pattern = "^%s*if err != nil {", placeholder = "if err != nil .." },
        },
      },
    },
  },

  -- {
  --   "ludovicchabant/vim-gutentags",
  --   -- lazy = false,
  --   event = { "BufNewFile", "BufReadPost" },
  --   config = function()
  --     require "custom.configs.tags"
  --   end,
  -- },

  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = {},
  },


}

return plugins
