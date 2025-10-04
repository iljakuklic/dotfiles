-- Add some packages
require('pckr').add {
    -- Package management
    'wbthomason/packer.nvim';

    -- UI
    'tomasiser/vim-code-dark';
    --'folke/which-key.nvim'; -- TODO configure
    { 'hoob3rt/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    };
    { 'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        requires = {'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep', 'nvim-tree/nvim-web-devicons'}
    };

    -- General editing
    'editorconfig/editorconfig-vim';
    'hrsh7th/nvim-cmp';
    'neovim/nvim-lspconfig';
    'hrsh7th/cmp-nvim-lsp';
}

