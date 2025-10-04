local function load_json_config(path)
  return vim.fn.json_decode(table.concat(vim.fn.readfile(path), "\n"))
end

-- Rust
vim.lsp.enable('rust_analyzer')

-- LSP AI
vim.lsp.config('lsp_ai', {
    root_markers = { '.git' },
    filetypes = { 'rust' },
    init_options = load_json_config(vim.fn.stdpath("config") .. "/lsp-ai.json"),
})
vim.lsp.enable('lsp_ai')
