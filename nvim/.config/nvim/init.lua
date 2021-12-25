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
    use { 'neovim/nvim-lspconfig' }
    use 'hrsh7th/cmp-nvim-lsp'
    --use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/nvim-cmp'
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

-- Completion
local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
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
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        --{ name = 'buffer' },
    })
})

-- Language servers
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

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
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local lsp_servers = { 'rust_analyzer' }
local lsp_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in ipairs(lsp_servers) do
    nvim_lsp[lsp].setup {
        capabilities = lsp_capabilities,
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150,
        }
    }
end

-- Key bindings
keymap = vim.api.nvim_set_keymap
keymap('n', '<C-l>', ':nohlsearch<CR><C-l>', {noremap = true, silent = true})
