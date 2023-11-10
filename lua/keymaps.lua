-- [[ Basic Keymaps ]]

-- Functional wrapper for mapping custom keybindings
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

local project_files = function()
  -- call via:
  -- :lua require"telescope-config".project_files()

  -- example keymap:
  -- vim.api.nvim_set_keymap("n", "<Leader><Space>", "<CMD>lua require'telescope-config'.project_files()<CR>", {noremap = true, silent = true})

  local opts = {} -- define here if you want to define something
  vim.fn.system('git rev-parse --is-inside-work-tree')
  if vim.v.shell_error == 0 then
    require "telescope.builtin".git_files(opts)
  else
    require "telescope.builtin".find_files(opts)
  end
end
-- Old Telescope stuff
vim.keymap.set("n", "//", project_files, { silent = true })
vim.keymap.set("n", ";r", require('telescope.builtin').live_grep, { silent = true })
vim.keymap.set("n", "\\\\", require('telescope.builtin').buffers, { silent = true })
vim.keymap.set("n", ";;", require('telescope.builtin').help_tags, { silent = true })

-- " ESC with jj
map("i", "jj", "<ESC>")

-- " Center search matches
map("n", "n", "nzz")

-- " Quickly edit/reload the vimrc file
map("n", "<leader>ev", ":e $MYVIMRC<CR>", { silent = true })
map("n", "<leader>sv", ":so $MYVIMRC<CR>", { silent = true })

-- " Let space bar toggle folding on and off.
--
map("n", "<Space>", "za")
-- " Allow repeat in visual mode
map("v", ".", ":norm.<CR>")

-- " Preserve indentation while pasting text from the OS X clipboard
map("n", "<leader>p", ":set paste<CR>:put  *<CR>:set nopaste<CR>")

-- " Tab goes switches between matched surrounding tokens
map("n", "<tab>", "%")
map("v", "<tab>", "%")

-- " Clear search
map("n", "<leader>,", ":noh<cr>")

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

vim.keymap.set('n', '<C-h>', "<cmd> TmuxNavigateLeft<CR>", {desc = "Window left"})
vim.keymap.set('n', '<C-l>', "<cmd> TmuxNavigateRight<CR>", {desc = "Window right"})
vim.keymap.set('n', '<C-j>', "<cmd> TmuxNavigateDown<CR>", {desc = "Window down"})
vim.keymap.set('n', '<C-k>', "<cmd> TmuxNavigateUp<CR>", {desc = "Window up"})

-- vim: ts=2 sts=2 sw=2 et
