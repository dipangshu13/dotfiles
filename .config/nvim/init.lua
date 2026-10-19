-- ==========================================
-- NEOVIM CONFIG - MODERN SETUP (v0.12+)
-- ==========================================

-- 1. Basic Settings
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers
vim.opt.tabstop = 4            -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4         -- Number of spaces for autoindent
vim.opt.expandtab = true       -- Convert tabs to spaces
vim.opt.smartindent = true     -- Smart auto-indenting
vim.opt.wrap = false           -- Don't wrap long lines
vim.opt.termguicolors = true   -- Enable 24-bit RGB colors
vim.opt.cursorline = true      -- Highlight the current line
vim.opt.ignorecase = true      -- Ignore case when searching
vim.opt.smartcase = true       -- Unless you type a capital letter
vim.opt.clipboard = "unnamedplus" -- Use system clipboard

-- 2. Bootstrap the Plugin Manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Install Plugins
require("lazy").setup({
    -- Theme (Tokyo Night, matching your terminal)
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                transparent = true,
            })
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },
    -- File Tree (Like VS Code sidebar)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
        end,
    },
    -- Status Line (Bottom bar)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({ options = { theme = "tokyonight" } })
        end,
    },
    -- Fuzzy Finder (Like Wofi, but for files inside Neovim)
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            -- Keybind: Space + f + f to find files
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            -- Keybind: Space + f + g to search text inside files
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        end,
    },
    -- Syntax Highlighting (Treesitter - NEW MAIN BRANCH API)
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main", -- Required for Neovim 0.12+
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")
            local languages = { "lua", "vim", "vimdoc", "javascript", "html", "css" }

            -- Install the parsers
            ts.install(languages)

            -- Enable highlighting and indentation for these languages
            vim.api.nvim_create_autocmd("FileType", {
                pattern = languages,
                callback = function()
                    vim.treesitter.start()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
})

-- 4. Keybindings
-- Set Space as the "leader" key (like Super in Sway)
vim.g.mapleader = " "

-- Toggle File Tree with Space + e
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Save file with Space + w
vim.keymap.set("n", "<leader>w", ":w<CR>")

-- Quit with Space + q
vim.keymap.set("n", "<leader>q", ":q<CR>")
