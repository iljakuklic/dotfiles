local function load_json_config(path)
  return vim.fn.json_decode(table.concat(vim.fn.readfile(path), "\n"))
end

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
