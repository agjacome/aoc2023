local group   = vim.api.nvim_create_augroup('aoc2023', {})
local autocmd = vim.api.nvim_create_autocmd

autocmd('BufWritePost', {
    group   = group,
    pattern = '**.nix',
    command = [[silent !nix fmt %]]
})

autocmd('BufWritePost', {
    group   = group,
    pattern = '**.nim',
    command = [[silent !nimpretty --indent:4 --maxLineLen:100 %]]
})

vim.keymap.set('n', '<leader>t', '<cmd>!nimble test %<cr>', { noremap = true })
