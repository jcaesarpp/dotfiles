local opt = vim.opt

opt.number = true          -- Muestra números de línea
opt.relativenumber = true  -- Números relativos (clave para moverte rápido)
opt.mouse = 'a'            -- Permite usar el mouse
opt.ignorecase = true      -- Ignorar mayúsculas al buscar
opt.smartcase = true       -- No ignorar si hay una mayúscula en la búsqueda
opt.termguicolors = true   -- Colores reales en la terminal (ideal para Alacritty)
opt.tabstop = 4            -- Tamaño de tabulación
opt.shiftwidth = 4
opt.expandtab = true       -- Convertir tabs en espacios
opt.clipboard = "unnamedplus" -- Sincronizar con el portapapeles del sistema

-- Tecla líder (espacio es la más cómoda en Neovim)
--vim.g.mapleader = " "

