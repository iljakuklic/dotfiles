-- Aliases
fn = vim.fn

-- Set up package manager
local packer_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(packer_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path})
  vim.cmd 'packadd packer.nvim'
end

-- Add some packages
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'editorconfig/editorconfig-vim'
    use 'tomasiser/vim-code-dark'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'SmiteshP/nvim-gps', requires = 'nvim-treesitter/nvim-treesitter' }
    use { 'hoob3rt/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
end)

-- Editing
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.history = 1000

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
local function keymap(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

keymap('n', '<C-l>', ':nohlsearch<CR><C-l>', {silent = true})
