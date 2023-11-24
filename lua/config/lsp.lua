local M = {}

-- Helper function for creating keymaps
local function nnoremap(rhs, lhs, bufopts, desc)
  bufopts.desc = desc
  vim.keymap.set('n', rhs, lhs, bufopts)
end

local on_attach = function(client, bufnr)
  local telescope = require 'telescope.builtin'
  -- Regular Neovim LSP client keymappings
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  nnoremap('gD', vim.lsp.buf.type_definition, bufopts, 'Go to type definition')
  nnoremap('gd', telescope.lsp_definitions, bufopts, 'Go to definition')
  nnoremap('gi', telescope.lsp_implementations, bufopts, 'Go to implementation')
  nnoremap('K', vim.lsp.buf.hover, bufopts, 'Hover text')
  -- TODO: Map this to something else
  -- nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, "Show signature")
  nnoremap('<leader>rn', vim.lsp.buf.rename, bufopts)
  nnoremap('<leader>gr', telescope.lsp_references, bufopts, 'Get references')

  nnoremap('<leader>ca', vim.lsp.buf.code_action, bufopts, 'Code Actions')
  vim.keymap.set(
    'v',
    '<leader>ca',
    '<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>',
    { noremap = true, silent = true, buffer = bufnr, desc = 'Code actions' }
  )

  -- nnoremap('<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts, "Format file")
  vim.api.nvim_create_user_command('Format', function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ['end'] = { args.line2, end_line:len() },
      }
    end
    require('conform').format { async = true, lsp_fallback = true, range = range }
  end, { range = true })

  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   vim.lsp.buf.format()
  -- end, { desc = 'Format current buffer with LSP' })
  nnoremap('<leader>qf', telescope.quickfix, bufopts, 'Open quickfix')

  nnoremap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts, 'List workspace folders')

  nnoremap('<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts, 'Add workspace folder')
  nnoremap('<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts, 'Remove workspace folder')

  -- Show diagnostics in a floating window
  nnoremap('gl', vim.diagnostic.open_float, bufopts)
  -- Move to the previous diagnostic
  nnoremap('[d', vim.diagnostic.goto_prev, bufopts)
  -- Move to the next diagnostic
  nnoremap(']d', vim.diagnostic.goto_next, bufopts)
  vim.lsp.inlay_hint.enable(bufnr, true)
end

M.on_attach = on_attach

M.on_attach_java = function(client, bufnr)
  local jdtls = require 'jdtls'
  local jdtls_setup = require 'jdtls.setup'

  -- Regular Neovim LSP client keymappings
  on_attach(client, bufnr)

  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  -- Java extensions provided by jdtls
  nnoremap('<leader>o', jdtls.organize_imports, bufopts, 'Organize imports')
  nnoremap('<space>ev', jdtls.extract_variable, bufopts, 'Extract variable')
  nnoremap('<space>ec', jdtls.extract_constant, bufopts, 'Extract constant')
  vim.keymap.set(
    'v',
    '<space>em',
    [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    { noremap = true, silent = true, buffer = bufnr, desc = 'Extract method' }
  )

  -- " If using nvim-dap
  -- " This requires java-debug and vscode-java-test bundles, see install steps in this README further below.
  nnoremap('<leader>df', jdtls.test_class, bufopts, 'Test class')
  nnoremap('<leader>dn', jdtls.test_nearest_method, bufopts, 'Test nearest method')

  jdtls.setup_dap {
    config_overrides = {
      vmArgs = '-ea -javaagent:/Volumes/brazil-pkg-cache/packages/Maven-org-aspectj_aspectjweaver/Maven-org-aspectj_aspectjweaver-1.9.x.3275.0/AL2_x86_64/DEV.STD.PTHREAD/build/lib/aspectjweaver-1.9.6.jar',
    },
    hotcodereplace = 'auto',
  }

  vim.lsp.inlay_hint.enable(bufnr, true)
  -- vim.lsp.buf.inlay_hint(bufnr, true)
  -- jdtls.dap.setup_dap_main_class_configs()
  -- jdtls_setup.add_commands()
  require('dapui').setup()
end

return M
