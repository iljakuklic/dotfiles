-- Set up package manager
local pckr_path = vim.fn.stdpath('data')..'/pckr/pckr.nvim'

if not (vim.uv or vim.loop).fs_stat(pckr_path) then
  vim.fn.system({'git', 'clone', '--depth=1', 'https://github.com/lewis6991/pckr.nvim', pckr_path})
end

vim.opt.rtp:prepend(pckr_path)
