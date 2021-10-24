-- Set up package manager
local packer_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.isdirectory(packer_path) then
  vim.fn.system({'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', packer_path})
  vim.cmd 'packadd packer.nvim'
end

-- Add some packages
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'editorconfig/editorconfig-vim'
    use 'tomasiser/vim-code-dark'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'SmiteshP/nvim-gps', requires = 'nvim-treesitter/nvim-treesitter' }
    use { 'nvim-treesitter/nvim-treesitter-textobjects', requires = 'nvim-treesitter/nvim-treesitter' }
    use { 'nvim-treesitter/playground', requires = 'nvim-treesitter/nvim-treesitter', cmd = 'TSPlaygroundToggle' }
    use { 'hoob3rt/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
end)

-- Editing
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.smartindent = true
vim.o.history = 1000
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('data')..'/undo'

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

-- UI
vim.o.hidden = true
vim.o.scrolloff = 2
vim.o.sidescrolloff = 5
vim.o.wildmenu = true
vim.o.number = true
vim.o.signcolumn = 'yes'
vim.wo.list = true
vim.o.listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:␣,trail:·'
vim.o.colorcolumn = '+1'

-- Colours
vim.cmd('colorscheme codedark')
vim.cmd('au ColorScheme * hi Normal ctermbg=none')
vim.cmd('au ColorScheme * hi EndOfBuffer ctermbg=none')
vim.cmd('au ColorScheme * hi NonText ctermbg=none')

-- Treesitter
vim.cmd('packadd nvim-treesitter')
require('nvim-treesitter.configs').setup {
    ensure_installed = 'maintained',
    highlight = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "[n",
            node_incremental = "[n",
            node_decremental = "]n",
            scope_incremental = "[N",
        }
    },
    playground = {
        enable = true,
        persist_queries = true,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
    },
}

-- Status line
nvim_gps = require('nvim-gps')
nvim_gps.setup({ separator = '  ' })
require('lualine').setup {
    sections = {
        lualine_c = {
            { 'filename', path = 1 },
            { nvim_gps.get_location, condition = nvim_gps.is_available },
        },
        lualine_x = {},
    },
}

-- Key bindings
keymap = vim.api.nvim_set_keymap
keymap('n', '<C-l>', ':nohlsearch<CR><C-l>', {noremap = true, silent = true})
