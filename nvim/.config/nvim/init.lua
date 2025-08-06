-- Set up package manager
local packer_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.isdirectory(packer_path) then
  vim.fn.system({'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', packer_path})
  vim.cmd 'packadd packer.nvim'
end

-- Add some packages
require('packer').startup(function()
    -- Package management
    use 'wbthomason/packer.nvim'

    -- UI
    use 'tomasiser/vim-code-dark'
    use { 'hoob3rt/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.8', requires = {
        'nvim-lua/plenary.nvim', 'BurntSushi/ripgrep', 'nvim-tree/nvim-web-devicons'
    } }

    -- General editing
    use 'editorconfig/editorconfig-vim'
    use 'L3MON4D3/LuaSnip'
    use 'hrsh7th/nvim-cmp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'

    -- Language support
    use 'simrat39/rust-tools.nvim'
end)

-- Utility functions

local function keymap(mode, key, cmd)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap(mode, key, cmd, opts)
end

local function load_json_config(path)
  return vim.fn.json_decode(table.concat(vim.fn.readfile(path), "\n"))
end

-- Editing
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.smartindent = true
vim.o.history = 1000
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath('data')..'/undo'
vim.o.spell = true

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

-- Snippets
local luasnip = require('luasnip')

-- Completion
local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-Up>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-Down>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }),
})

local lsp_config = {
    on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
    --standalone = true,
    flags = { debounce_text_changes = 150 },
}

-- Set up servers
require('rust-tools').setup({
    tools = {
        inlay_hints = {
            show_parameter_hints = false,
            other_hints_prefix = ": ",
            highlight = 'NonText',
        },
    },
    server = lsp_config,
})

-- LSP AI
vim.lsp.config('lsp_ai', {
    root_markers = { '.git' },
    filetypes = { 'rust' },
    init_options = load_json_config(vim.fn.stdpath("config") .. "/lsp-ai.json"),
})
vim.lsp.enable('lsp_ai')

-- Key bindings

-- General
keymap('n', '<C-l>', ':nohlsearch<CR><C-l>')

-- LSP jumps
keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')

-- LSP help
keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
keymap('i', '<C-k>', '<C-o><cmd>lua vim.lsp.buf.signature_help()<CR>')
keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

-- LSP commands
keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
keymap('', '<leader>n', '<cmd>lua vim.lsp.buf.rename()<CR>')
keymap('', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
keymap('', '<leader>f', '<cmd>lua vim.lsp.buf.format { async = true }<CR>')

-- Telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>sg', telescope.live_grep, { desc = 'Telescope grep' })
vim.keymap.set('n', '<leader>sb', telescope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>sr', telescope.lsp_references, { desc = 'Telescope references' })
vim.keymap.set('n', '<leader>ss', telescope.lsp_workspace_symbols, { desc = 'Telescope symbols' })
vim.keymap.set('n', '<leader>gc', telescope.git_commits, { desc = 'Telescope git commits' })
vim.keymap.set('n', '<leader>gf', telescope.git_bcommits, { desc = 'Telescope git current file commits' })
vim.keymap.set('n', '<leader>gb', telescope.git_branches, { desc = 'Telescope git branches' })
