-- Visuals
vim.opt.number = true -- show line numbers
vim.opt.cursorline = true -- highlight the line with the cursor

-- Indentation
vim.opt.expandtab = true -- use spaces, not tabs, by default
vim.opt.smartindent = true -- automatically indent and dedent
vim.opt.shiftwidth = 2 -- shift left and right by 2
vim.opt.softtabstop = 2 -- insert 2 spaces when typing <Tab>

-- Search
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- stop ignoring case when uppercase is used

-- Leader
vim.g.mapleader = " " -- set the leader key to <Space>

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

-- Initialize plugins
local plugins = {
  { "folke/which-key.nvim" }, -- show keybinding help as you type
  { "itchyny/lightline.vim", lazy = false }, -- a useful status bar

  { "tpope/vim-repeat" }, -- better repeat (`.`) semantics
  { "tpope/vim-surround" }, -- add, remove, and modify surrounding characters

  { "christoomey/vim-tmux-navigator" }, -- navigate tmux easily
}
require("lazy").setup(plugins)
