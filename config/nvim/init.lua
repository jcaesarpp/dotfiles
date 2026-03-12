
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = ''
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.clipboard = "unnamedplus"

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>w', ':set wrap!<CR>')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  "tpope/vim-surround",
  "tpope/vim-fugitive",
  "tpope/vim-speeddating",
  "tribela/vim-transparent",
  "wuelnerdotexe/vim-enfocado",
  
  --"nvim-tree/nvim-tree.lua",
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",

  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
})

require("mason").setup()
require("mason-lspconfig").setup()
--require('lspconfig').bashls.setup({})
--
---- Ver errores de Shellcheck (Diagnostics) con Espacio + d
--vim.keymap.set('n', '<leader>d', vim.diagnostic.setqflist, { desc = "Ver errores de Shellcheck" })
--
---- Saltar al siguiente error con ]d y al anterior con [d
--vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
--vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)

-- Abrir/Cerrar el explorador de archivos con Espacio + e
--vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })

-- Buscador de archivos con Espacio + f (Files)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})

-- Buscar texto dentro de los archivos con Espacio + g (Grep)
-- (Requiere que tengas instalado 'ripgrep' en Ubuntu)
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})

vim.cmd.colorscheme "catppuccin"

