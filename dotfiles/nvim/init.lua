-- Visuals
vim.opt.number = true -- show line numbers
vim.opt.cursorline = true -- highlight the line with the cursor
vim.opt.colorcolumn = "81,121" -- mark 80 and 120 columns
vim.opt.termguicolors = true -- enable 24-bit colors

-- Editing
vim.opt.commentstring = '# %s' -- default to '#' as a comment character

-- Indentation
vim.opt.expandtab = true -- use spaces, not tabs, by default
vim.opt.smartindent = true -- automatically indent and dedent
vim.opt.shiftwidth = 2 -- shift left and right by 2
vim.opt.softtabstop = 2 -- insert 2 spaces when typing <Tab>
vim.opt.tabstop = 2 -- render tabs as 2 spaces
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*.go",
  callback = function()
    vim.opt_local.expandtab = false
  end,
})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*.rs",
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.tabstop = 4
  end,
})

-- Search
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- stop ignoring case when uppercase is used

-- Save and load
---- reload the file when re-entering the buffer
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  pattern = "*",
  command = "checktime",
})
---- save the file when leaving the buffer
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  pattern = "*",
  callback = function(event)
    -- only for normal buffers
    if not vim.bo[event.buf].buftype then
      vim.cmd("update")
    end
  end,
})
---- save when moving around using tmux navigator
vim.g.tmux_navigator_save_on_switch = 1

-- Leader
vim.g.mapleader = " " -- set the leader key to <Space>

-- Disable netrw in favor of nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set up lazy.nvim, the plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

---- Update plugins weekly
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local lazy_update_timestamp_path = vim.env.HOME .. "/.cache/nvim/update.timestamp"
    local lazy_update_timestamp_file = io.open(lazy_update_timestamp_path, "r")
    if lazy_update_timestamp_file then
      lazy_update_timestamp = tonumber(lazy_update_timestamp_file:read("a"))
      print(lazy_update_timestamp)
      lazy_update_timestamp_file:close()
    else
      lazy_update_timestamp = 0
    end

    current_timestamp = os.time()
    if current_timestamp > lazy_update_timestamp + (60 * 60 * 24 * 7) then -- update weekly
      require("lazy").update()
      lazy_update_timestamp_file = assert(io.open(lazy_update_timestamp_path, "w"))
      lazy_update_timestamp_file:write(tostring(current_timestamp))
      lazy_update_timestamp_file:close()
    end
  end
})

-- Initialize plugins
local plugins = {
  { "folke/tokyonight.nvim", lazy = false }, -- pretty colors

  { "tpope/vim-repeat" }, -- better repeat (`.`) semantics
  { "tpope/vim-surround" }, -- add, remove, and modify surrounding characters
  { "tpope/vim-commentary" }, -- comment and uncomment lines

  { "christoomey/vim-tmux-navigator" }, -- navigate tmux easily
  { "folke/which-key.nvim" }, -- show keybinding help as you type

  { "akinsho/bufferline.nvim", -- buffers as tabs
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  { "nvim-lualine/lualine.nvim", -- a useful status bar
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
  { "nvim-telescope/telescope.nvim", -- fuzzy search
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  { "nvim-telescope/telescope-ui-select.nvim" }, -- override the selection UI with Telescope
  { "nvim-tree/nvim-tree.lua", -- file browsing
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    tag = "nightly",
  },

  { "nvim-treesitter/nvim-treesitter" }, -- syntax highlighting
  { "neovim/nvim-lspconfig" }, -- LSP helpers
  { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" }, -- multiple LSP diagnostics per line
}
require("lazy").setup(plugins)

-- Set the color scheme
vim.cmd("colorscheme tokyonight-night") -- seems to work best with my Alacritty theme

-- Initialize plugins that need it
require("bufferline").setup()
require("lualine").setup()
require("nvim-tree").setup()

-- Set up fuzzy search and the fancy selection UI
require("telescope").setup {
  defaults = {
    layout_strategy = "vertical", -- better for thinner windows
    file_ignore_patterns = {
      "^%.git/", -- explicitly filter out any files in the .git directory
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
  },
}
require("telescope").load_extension("ui-select")

-- Set up syntax highlighting
---- grammars are managed by home-manager
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Configure LSP servers
local lspconfig = require("lspconfig")
---- a little hack to get the environment from direnv before running
---- to do:
----   - add a command for "allow"
----   - add a command for "deny"
----   - handle errors nicely
----   - factor into a plugin
lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup, function(config)
  config.cmd = { "direnv", "exec", ".", unpack(config.cmd) }
end)
lspconfig.hls.setup {
  filetypes = { "haskell", "lhaskell", "cabal" }, -- configure HLS to run on Cabal files too
}
lspconfig.pyright.setup {}
lspconfig.rust_analyzer.setup {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
      },
    },
  },
}
lspconfig.tsserver.setup {}

-- Use lsp_lines for diagnostics
require("lsp_lines").setup()
vim.diagnostic.config({
  virtual_text = false,
})

-- Reformat code on write, if LSP is initialized.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(lsp_event)
    vim.api.nvim_create_autocmd("BufWrite", {
      buffer = lsp_event.buf,
      callback = function(event)
        vim.lsp.buf.format({
          bufnr = event.buf,
          async = false,
          timeout_ms = 250,
        })
      end,
    })
  end
})

-- Set up key bindings
local nvimTreeApi = require("nvim-tree.api")
local telescopeBuiltin = require("telescope.builtin")
local wk = require("which-key")

---- bind my foot pedal to insert mode
----   on press, sends <F12>
----   on release, sends <F11>
vim.keymap.set("n", "<F12>", "i", { noremap = true })
vim.keymap.set({"i", "v"}, "<F12>", "", { noremap = true }) -- do nothing when already there
vim.keymap.set({"i", "v"}, "<F11>", "<Esc>", { noremap = true })

---- most keybindings are behind the Leader key
wk.register({
  a = { vim.lsp.buf.code_action, "action" },
  b = {
    name = "buffers",
    b = { telescopeBuiltin.buffers, "all" },
    d = {
      name = "close",
      d = { "<cmd>bdelete<cr>", "this" },
      o = { "<cmd>BufferLineCloseOthers<cr>", "others" },
      h = { "<cmd>BufferLineCloseLeft<cr>", "to the left" },
      l = { "<cmd>BufferLineCloseRight<cr>", "to the right" },
    },
    n = { "<cmd>BufferLineCycleNext<cr>", "next" },
    p = { "<cmd>BufferLineCyclePrev<cr>", "previous" },
    N = { "<cmd>BufferLineMoveNext<cr>", "move next" },
    P = { "<cmd>BufferLineMovePrev<cr>", "move previous" },
  },
  d = {
    name = "diagnostics",
    d = { telescopeBuiltin.diagnostics, "all" },
    n = { vim.diagnostic.goto_next, "go to next" },
    p = { vim.diagnostic.goto_prev, "go to previous" },
  },
  f = {
    name = "files",
    f = { function() telescopeBuiltin.find_files({ hidden = true }) end, "all" },
    r = { telescopeBuiltin.oldfiles, "recent" },
    s = { "<cmd>write<cr>", "save" },
    t = { function() nvimTreeApi.tree.open({ find_file = true }) end, "tree" },
  },
  g = {
    name = "git",
    s = { telescopeBuiltin.git_status, "status" },
  },
  j = {
    name = "jump to",
    D = { vim.lsp.buf.declaration, "declaration" },
    d = { telescopeBuiltin.lsp_definitions, "definition" },
    i = { telescopeBuiltin.lsp_implementations, "implementation" },
    r = { telescopeBuiltin.lsp_references, "references" },
    t = { telescopeBuiltin.lsp_type_definitions, "type definition" },
  },
  r = {
    name = "refactor",
    f = { vim.lsp.buf.format, "format" },
    r = { vim.lsp.buf.rename, "rename" },
  },
  s = {
    name = "search",
    c = { "<cmd>nohlsearch<cr>", "clear highlight" },
    r = { telescopeBuiltin.resume, "resume" },
    s = { function() telescopeBuiltin.live_grep({ hidden = true }) end, "text" },
    w = { telescopeBuiltin.grep_string, "current word" },
  },
}, { prefix = "<leader>" })

---- but not everything
wk.register({
  K = { vim.lsp.buf.hover, "hover" },
  ["<C-Left>"] = { "<cmd>BufferLineCyclePrev<cr>", "previous buffer" },
  ["<C-Right>"] = { "<cmd>BufferLineCycleNext<cr>", "next buffer" },
  ["<C-S-Left>"] = { "<cmd>BufferLineMovePrev<cr>", "move buffer to previous" },
  ["<C-S-Right>"] = { "<cmd>BufferLineMoveNext<cr>", "move buffer to next" },
})
