-- Add some packages
require('pckr').add {
    -- Package management
    'wbthomason/packer.nvim';

    -- UI
    'tomasiser/vim-code-dark';
    { 'hoob3rt/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    };
    { 'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        requires = {'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep', 'nvim-tree/nvim-web-devicons'}
    };

    -- General editing
    'editorconfig/editorconfig-vim';
    'L3MON4D3/LuaSnip';
    'hrsh7th/nvim-cmp';
    'saadparwaiz1/cmp_luasnip';
    'neovim/nvim-lspconfig';
    'hrsh7th/cmp-nvim-lsp';

    -- Language support
    'simrat39/rust-tools.nvim',
}

