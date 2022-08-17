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
    use { 'SmiteshP/nvim-gps', requires = 'nvim-treesitter/nvim-treesitter' }
    use { 'hoob3rt/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
    use { 'neovim/nvim-lspconfig' }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/nvim-cmp'
    use 'simrat39/rust-tools.nvim'
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

-- Completion
local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ['<C-Up>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-Down>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            --elseif luasnip.expand_or_jumpable() then
            --    luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            --elseif luasnip.jumpable(-1) then
            --    luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        --{ name = 'buffer' },
    })
})

-- Language servers
local nvim_lsp = require('lspconfig')

local on_lsp_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mapping opts
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<leader>n', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- LSP configuration options
local lsp_config = {
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = on_lsp_attach,
    --standalone = true,
    flags = { debounce_text_changes = 150 },
}

--nvim_lsp.rust_analyzer.setup(lsp_config)
require('rust-tools').setup({
    tools = {},
    server = lsp_config,
})

-- Key bindings
keymap = vim.api.nvim_set_keymap
keymap('n', '<C-l>', ':nohlsearch<CR><C-l>', {noremap = true, silent = true})
