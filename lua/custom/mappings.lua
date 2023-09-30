
local M = {}

local function move_or_create_win(key)
  local fn = vim.fn
  local curr_win = fn.winnr()
  vim.cmd("wincmd " .. key) --> attempt to move

  if curr_win == fn.winnr() then --> didn't move, so create a split
    if key == "h" or key == "l" then
      vim.cmd "wincmd v"
    else
      vim.cmd "wincmd s"
    end

    vim.cmd("wincmd " .. key)
  end
end

M.disabled = {
  n = {
    ["<leader>b"] = "",
    ["<leader>rn"] = { ""}
  },
}

M.general = {
  n = {
    -- Keep cursor in the center line when C-D / C-U
    ["<C-d>"] = { "<C-d>zz", " Scroll down", opts = { silent = true } },
    ["<C-u>"] = { "<C-u>zz", " Scroll up", opts = { silent = true } },


    ["<leader><leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

    ["<leader>cs"] = { "<CMD>SymbolsOutline<CR>", " Symbols Outline" },
    ["<leader>tr"] = {
      function()
        require("base46").toggle_transparency()
      end,
      "󰂵 Toggle transparency",
    },
  }
}

M.Telescope = {
  n = {
    ["<leader>li"] = { "<CMD>Telescope highlights<CR>", "Highlights" },
    ["<leader>fk"] = { "<CMD>Telescope keymaps<CR>", " Find keymaps" },
    ["<leader>fs"] = { "<CMD>Telescope lsp_document_symbols<CR>", " Find document symbols" },
    ["<leader>fr"] = { "<CMD>Telescope frecency<CR>", " Recent files" },
    ["<leader>fu"] = { "<CMD>Telescope undo<CR>", " Undo tree" },
    ["<leader>fg"] = { "<CMD>Telescope ast_grep<CR>", " Structural Search" },
    ["<leader>fre"] = {
      function()
        require("telescope").extensions.refactoring.refactors()
      end,
      " Structural Search",
    },
    ["<leader>fz"] = {
      "<CMD>Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<CR>",
      " Find current file",
    },
    ["<leader>ff"] = {
      function()
        local builtin = require "telescope.builtin"
        -- ignore opened buffers if not in dashboard or directory
        if vim.fn.isdirectory(vim.fn.expand "%") == 1 or vim.bo.filetype == "alpha" then
          builtin.find_files()
        else
          local function literalize(str)
            return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c)
              return "%" .. c
            end)
          end

          local function get_open_buffers()
            local buffers = {}
            local len = 0
            local vim_fn = vim.fn
            local buflisted = vim_fn.buflisted

            for buffer = 1, vim_fn.bufnr "$" do
              if buflisted(buffer) == 1 then
                len = len + 1
                -- get relative name of buffer without leading slash
                buffers[len] = "^"
                  .. literalize(string.gsub(vim.api.nvim_buf_get_name(buffer), literalize(vim.loop.cwd()), ""):sub(2))
                  .. "$"
              end
            end

            return buffers
          end

          builtin.find_files {
            file_ignore_patterns = get_open_buffers(),
          }
        end
      end,
      "Find files",
    },
  },
}

M.treesitter = {
  n = {
    ["<leader>cu"] = { "<CMD>InspectTree <CR>", " Find highlight" },
    ["<leader>to"] = { "<CMD>TSJToggle<CR>", "󱓡 Toggle split/join" },
  },
}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line"
    },
    ["<leader>dr"] = {
      "<cmd> DapContinue <CR>",
      "Run or continue the debugger"
    },
    ["<leader>dus"] = {
      function ()
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.open();
      end,
      "Open debugging sidebar"
    }
  },
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require('dap-go').debug_test()
      end,
      "Debug go test"
    },
    ["<leader>dgl"] = {
      function()
        require('dap-go').debug_last()
      end,
      "Debug last go test"
    }
  }
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags"
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags"
    }
  }
}

M.lspsaga = {
  n = {
    ["<leader>."] = { "<CMD>CodeActionMenu<CR>", "󰅱 Code Action" },
    ["<leader>gf"] = {
      function()
        vim.cmd "Lspsaga finder"
      end,
      " Go to definition",
    },
    ["<leader>rn"] = {
      "<CMD>Lspsaga rename<CR>",
      " rename",
    },
    ["gd"] = {
      "<CMD>Lspsaga goto_definition<CR>",
      " Go to definition",
    },
    ["<leader>lp"] = {
      "<CMD>Lspsaga peek_definition<CR>",
      " Peek definition",
    },
    ["<leader>k"] = {
      -- "<CMD>Lspsaga hover_doc<CR>",
      function()
        require("pretty_hover").hover()
      end,
      "󱙼 Hover lsp",
    },
    ["<leader>o"] = { "<CMD>Lspsaga outline<CR>", " Show Outline" },
    --  LSP
    ["gr"] = { "<CMD>Telescope lsp_references<CR>", " Lsp references" },
    ["[d"] = { "<CMD>Lspsaga diagnostic_jump_prev<CR>", " Prev Diagnostic" },
    ["]d"] = { "<CMD>Lspsaga diagnostic_jump_next<CR>", " Next Diagnostic" },
    ["<leader>qf"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "󰁨 Lsp Quickfix",
    },
  },
}

M.hop = {
  n = {
    ["<leader><leader>w"] = { "<cmd> HopWord <CR>", "hint all words" },
    ["<leader><leader>b"] = { "<cmd> HopWord <CR>", "hint all words" },
    ["<leader><leader>j"] = { "<cmd> HopLine <CR>", "hint line" },
    ["<leader><leader>k"] = { "<cmd> HopLine <CR>", "hint line" },
  },
}

M.symbols_outline = {
  plugin = true,
  n = {
    ["<leader>s"] = {"<cmd> SymbolsOutline <CR>"}
  }
}

M.development = {
  n = {
    ["<leader>i"] = {
      function()
        require("nvim-toggler").toggle()
      end,
      "󰌁 Invert text",
    },
    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      " Lsp formatting",
    },
    ["<leader>bi"] = {
      function()
        require("nvim-biscuits").toggle_biscuits()
      end,
      "󰆘 Toggle context",
    },
    ["<A-p>"] = { "<CMD>Colortils picker<CR>", " Delete word" },
  },
}

M.nvimtree = {
  n = {
    ["<C-b>"] = { "<CMD> NvimTreeToggle <CR>", "󰔱 Toggle nvimtree" },
  },
  i = {
    ["<C-b>"] = { "<CMD> NvimTreeToggle <CR>", "󰔱 Toggle nvimtree" },
  },
}


M.split = {
  n = {
    ["<C-h>"] = {
      function()
        move_or_create_win "h"
      end,
      "[h]: Move to window on the left or create a split",
    },
    ["<C-j>"] = {
      function()
        move_or_create_win "j"
      end,
      "[j]: Move to window below or create a vertical split",
    },
    ["<C-k>"] = {
      function()
        move_or_create_win "k"
      end,
      "[k]: Move to window above or create a vertical split",
    },
    ["<C-l>"] = {
      function()
        move_or_create_win "l"
      end,
      "[l]: Move to window on the right or create a split",
    },
  },
}

M.text = {
  i = {
    -- Move line up and down
    ["<C-Up>"] = { "<CMD>m .-2<CR>==", "󰜸 Move line up" },
    ["<C-Down>"] = { "<CMD>m .+1<CR>==", "󰜯 Move line down" },

    -- Navigate
    ["<A-Left>"] = { "<ESC>I", " Move to beginning of line" },
    ["<A-Right>"] = { "<ESC>A", " Move to end of line" },
    ["<A-d>"] = { "<ESC>diw", " Delete word" },
    ["<S-CR>"] = {
      function()
        vim.cmd "normal o"
      end,
      " New line",
    },
  },

  n = {
    -- Navigate
    ["<C-Left>"] = { "<ESC>_", "󰜲 Move to beginning of line" },
    ["<C-Right>"] = { "<ESC>$", "󰜵 Move to end of line" },
    ["<C-a>"] = { "gg0vG", " Select all" },
    ["<F3>"] = { "n", " Next" },
    ["<S-F3>"] = { "N", " Previous" },
    -- Operations
    ["<C-z>"] = { "<CMD>u<CR>", "󰕌 Undo" },
    ["<C-r>"] = { "<CMD>redo<CR>", "󰑎 Redo" },
    ["<C-x>"] = { "x", "󰆐 Cut" },
    ["<C-v>"] = { "p", "󰆒 Paste" },
    ["<C-c>"] = { "y", " Copy" },
    ["p"] = { "p`[v`]=", "󰆒 Paste" },
    ["<leader><leader>d"] = { "viw", " Select word" },
    ["<leader>d"] = { 'viw"_di', " Delete word" },
    ["<C-Up>"] = { "<CMD>m .-2<CR>==", "󰜸 Move line up" },
    ["<C-Down>"] = { "<CMD>m .+1<CR>==", "󰜯 Move line down" },
    -- Renamer
    -- ["<leader>mrn"] = { "<CMD>:MurenToggle<CR>", "󱝪 Toggle Search" },
    ["<leader>sp"] = { "<CMD>:TSJToggle<CR>", "󰯌 Toggle split/join" },
    ["<A-d>"] = { "<CMD>:MCstart<CR>", "Multi cursor" },
    ["<leader>ra"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "󰑕 LSP rename",
    },
    -- ["<leader>mrn"] = {
    --   function()
    --     return ":IncRename " .. vim.fn.expand "<cword>"
    --   end,
    --   -- ":IncRename "
    --   "󰑕 Rename",
    --   opts = { expr = true },
    -- },
    -- Quit
    ["<Esc>"] = {
      function()
        vim.cmd "noh"
        vim.cmd "Noice dismiss"
      end,
      " Clear highlights",
      opts = { silent = true },
    },
  },

  v = {
    ["<C-Up>"] = { ":m'<-2<CR>gv=gv", "󰜸 Move selection up", opts = { silent = true } },
    ["<C-Down>"] = { ":m'>+1<CR>gv=gv", "󰜯 Move selection down", opts = { silent = true } },
    ["<Home>"] = { "gg", "Home" },
    ["<End>"] = { "G", "End" },
    ["y"] = { "y`]", "Yank and move to end" },
    -- Indent backward/forward:
    ["<"] = { "<gv", " Ident backward", opts = { silent = false } },
    [">"] = { ">gv", " Ident forward", opts = { silent = false } },

    ["<C-Left>"] = { "<ESC>_", "󰜲 Move to beginning of line" },
    ["<C-Right>"] = { "<ESC>$", "󰜵 Move to end of line" },
  },

  c = {
    -- Autocomplete for brackets:
    ["("] = { "()<left>", "Auto complete (", opts = { silent = false } },
    ["<"] = { "<><left>", "Auto complete <", opts = { silent = false } },
    ['"'] = { '""<left>', [[Auto complete "]], opts = { silent = false } },
    ["'"] = { "''<left>", "Auto complete '", opts = { silent = false } },
  },
}

M.window = {
  n = {
    ["<leader><leader>h"] = { "<CMD>vs <CR>", "󰤼 Vertical split", opts = { nowait = true } },
    ["<leader><leader>v"] = { "<CMD>sp <CR>", "󰤻 Horizontal split", opts = { nowait = true } },
  },
}

M.diagnostics = {
  n = {
    ["<leader>t"] = { "<CMD>TroubleToggle<CR>", "󰔫 Toggle warnings" },
    ["<leader>td"] = { "<CMD>TodoTrouble keywords=TODO,FIX,FIXME,BUG,TEST,NOTE<CR>", " Todo/Fix/Fixme" },
    ["<leader>el"] = { "<CMD>ErrorLensToggle<CR>", "󱇭 Toggle error lens" },
    ["<leader>ft"] = { "<CMD>TodoTelescope<CR>", " Telescope TODO" },
    ["<Leader>ll"] = {
      function()
        require("lsp_lines").toggle()
      end,
      " Toggle lsp_lines",
    },
  },
}

M.test = {
  n = {
    ["<leader>rt"] = {
      function()
        require("neotest").run.run(vim.fn.expand "%")
      end,
      "󰤑 Run neotest",
    },
  },
}

M.folder = {
  n = {
    ["<leader>a"] = {
      function()
        require("fold-cycle").toggle_all()
      end,
      "󰴋 Toggle folder",
    },
    ["<leader>fp"] = {
      function()
        require("fold-preview").toggle_preview()
      end,
      "󱞊 Fold preview",
    },
  },
}

M.searchbox = {
  n = {
    ["<C-F>"] = { "<CMD> SearchBoxMatchAll clear_matches=true<CR>", "󱘟 Search matching all" },
    ["<leader>sr"] = { "<CMD> SearchBoxReplace confirm=menu<CR>", " Replace" },
  },
}


return M

