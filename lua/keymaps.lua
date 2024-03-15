-- [[ Basic Keymaps ]]

-- Functional wrapper for mapping custom keybindings
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local minifiles_open = function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end

-- Mini Files
vim.keymap.set('n', '-', minifiles_open, { silent = true })

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

-- DAP
vim.keymap.set('n', "<leader>du", function() require("dapui").toggle({ }) end, {desc = "Dap UI" })
vim.keymap.set({'n', 'v'}, "<leader>de", function() require("dapui").eval() end, {desc = "Eval"})

vim.keymap.set('n', "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, {desc = "Breakpoint Condition"})
vim.keymap.set('n', "<leader>db", function() require("dap").toggle_breakpoint() end, {desc = "Toggle Breakpoint"})
vim.keymap.set('n', "<leader>dc", function() require("dap").continue() end, {desc = "Continue"})
vim.keymap.set('n', "<leader>da", function() require("dap").continue({ before = get_args }) end, {desc = "Run with Args"})
vim.keymap.set('n', "<leader>dC", function() require("dap").run_to_cursor() end, {desc = "Run to Cursor"})
vim.keymap.set('n', "<leader>dg", function() require("dap").goto_() end, {desc = "Go to line (no execute)"})
vim.keymap.set('n', "<leader>di", function() require("dap").step_into() end, {desc = "Step Into"})
vim.keymap.set('n', "<leader>dj", function() require("dap").down() end, {desc = "Down"})
vim.keymap.set('n', "<leader>dk", function() require("dap").up() end, {desc = "Up"})
vim.keymap.set('n', "<leader>dl", function() require("dap").run_last() end, {desc = "Run Last"})
vim.keymap.set('n', "<leader>do", function() require("dap").step_out() end, {desc = "Step Out"})
vim.keymap.set('n', "<leader>dO", function() require("dap").step_over() end, {desc = "Step Over"})
vim.keymap.set('n', "<leader>dp", function() require("dap").pause() end, {desc = "Pause"})
vim.keymap.set('n', "<leader>dr", function() require("dap").repl.toggle() end, {desc = "Toggle REPL"})
vim.keymap.set('n', "<leader>ds", function() require("dap").session() end, {desc = "Session"})
vim.keymap.set('n', "<leader>dt", function() require("dap").terminate() end, {desc = "Terminate"})
vim.keymap.set('n', "<leader>dw", function() require("dap.ui.widgets").hover() end, {desc = "Widgets"})

-- local project_files = function()
--   -- call via:
--   -- :lua require"telescope-config".project_files()
--
--   -- example keymap:
--   -- vim.api.nvim_set_keymap("n", "<Leader><Space>", "<CMD>lua require'telescope-config'.project_files()<CR>", {noremap = true, silent = true})
--
--   local opts = {} -- define here if you want to define something
--   vim.fn.system('git rev-parse --is-inside-work-tree')
--   -- if vim.v.shell_error == 0 then
--     local plenary = require("plenary")
--     local scandir = require("plenary.scandir")
--     -- check if in Brazil Project and if so find from root
--     local root_markers = { "packageInfo" }
--     local root_dir = require('jdtls.setup').find_root(root_markers)
--     if root_dir ~= nil then
--       local project_dirs = scandir.scan_dir(root_dir .. "/src", {only_dirs=true, respect_gitignore=true })
--       -- local project_dirs = {"/Users/gideonva/workplace/AssetPersonalizationService/src/ATVAssetPersonalization-Ranking", "/Users/gideonva/workplace/AssetPersonalizationService/src/ATVAssetPersonalization-Data"}
--       -- opts["cwd"] = root_dir
--       opts["search_dirs"] = project_dirs
--       -- opts["no_ignore"] = root_dir
--       require "telescope.builtin".find_files(opts)
--   --   else
--   --     require "telescope.builtin".git_files(opts)
--   --   end
--   --   require "telescope.builtin".git_files(opts)
--   -- else
--   --   require "telescope.builtin".find_files(opts)
--   end
-- end
-- vim: ts=2 sts=2 sw=2 et
