local function keymap(mode, key, cmd)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap(mode, key, cmd, opts)
end

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

