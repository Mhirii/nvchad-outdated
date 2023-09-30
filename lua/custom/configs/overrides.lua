local M = {}


M.telescope = {
  defaults = {
    preview = {
      filetype_hook = function(_, bufnr, opts)
        -- don't display jank pdf previews
        if opts.ft == "pdf" then
          require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Not displaying " .. opts.ft)
          return false
        end
        return true
      end,
    },
    file_ignore_patterns = {
      "node_modules",
      ".docker",
      ".git",
      "yarn.lock",
      "go.sum",
      "go.mod",
      "tags",
      "mocks",
      "refactoring",
    },
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
      },
    },
  },
  extensions_list = {
    "themes",
    "terms",
    "notify",
    "frecency",
    "undo",
    "vim_bookmarks",
    "ast_grep",
    "ctags_plus",
    "luasnip",
    "import",
    "dap",
  },
  extensions = {
    fzf = {
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
      fuzzy = true,
    },
    ast_grep = {
      command = {
        "sg",
        "--json=stream",
        "-p",
      },
      grep_open_files = false,
      lang = nil,
    },
    import = {
      insert_at_top = true,
    },
  },
}

M.blankline = {
  filetype_exclude = {
    "help",
    "terminal",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "nvcheatsheet",
    "lsp-installer",
    "norg",
    "Empty",
    "Trouble",
    "lazy",
    "",
  },
  buftype_exclude = { "terminal", "nofile" },
  show_end_of_line = true,
  show_foldtext = true,
  show_trailing_blankline_indent = false,
  show_first_indent_level = true,
  show_current_context = true,
  show_current_context_start = true,
  -- Uncomment this line to enable rainbown identation
  -- char_highlight_list = hl_list,
}


M.treesitter = {
  auto_install = true,
  ensure_installed = {
    "vim",
    "lua",
    "bash",
    "json",
    "json5",
    "jq",
    "yaml",
    "java",
    "dockerfile",
    "regex",
    "toml",

    -- Markdown
    "markdown",
    "markdown_inline",
    -- Go Lang
    "go",
    "gomod",
    "gowork",
    "gosum",

    -- Web Dev
    "javascript",
    "typescript",
    "tsx",
    "html",
    "astro",
    "css",
  },
  indent = {
    enable = true,
  },
  playground = {
    enable = true,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
  textsubjects = {
    enable = true,
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
      ["i;"] = "textsubjects-container-inner",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      include_surrounding_whitespace = true,
      keymaps = {
        ["af"] = { query = "@function.outer", desc = "ts: all function" },
        ["if"] = { query = "@function.inner", desc = "ts: inner function" },
        ["ac"] = { query = "@class.outer", desc = "ts: all class" },
        ["ic"] = { query = "@class.inner", desc = "ts: inner class" },
        ["aC"] = { query = "@conditional.outer", desc = "ts: all conditional" },
        ["iC"] = { query = "@conditional.inner", desc = "ts: inner conditional" },
        ["aH"] = { query = "@assignment.lhs", desc = "ts: assignment lhs" },
        ["aL"] = { query = "@assignment.rhs", desc = "ts: assignment rhs" },
      },
    },
  },
  tree_setter = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = false,
    max_file_lines = 1000,
    query = {
      "rainbow-parens",
      html = "rainbow-tags",
      javascript = "rainbow-tags-react",
      tsx = "rainbow-tags",
    },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  autotag = {
    enable = true,
  },
}

return M
