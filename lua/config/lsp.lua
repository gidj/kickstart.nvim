local M = {}

-- Helper function for creating keymaps
local function nnoremap(rhs, lhs, bufopts, desc)
    bufopts.desc = desc
    vim.keymap.set("n", rhs, lhs, bufopts)
end

local on_attach = function(client, bufnr)
    local telescope = require('telescope.builtin')
    -- Regular Neovim LSP client keymappings
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    nnoremap('gD', vim.lsp.buf.type_definition, bufopts, "Go to type definition")
    nnoremap('gd', telescope.lsp_definitions, bufopts, "Go to definition")
    nnoremap('gi', telescope.lsp_implementations, bufopts, "Go to implementation")
    nnoremap('K', vim.lsp.buf.hover, bufopts, "Hover text")
    nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, "Show signature")
    nnoremap('<leader>rn', vim.lsp.buf.rename, bufopts)
    nnoremap("<leader>gr", telescope.lsp_references, bufopts, "Get references")

    nnoremap('<leader>ca', vim.lsp.buf.code_action, bufopts, "Code Actions")
    vim.keymap.set('v', "<leader>ca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
        { noremap = true, silent = true, buffer = bufnr, desc = "Code actions" })

    nnoremap('<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts, "Format file")
    nnoremap('<leader>qf', telescope.quickfix, bufopts, "Open quickfix")

    nnoremap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts, "List workspace folders")

    nnoremap('<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
    nnoremap('<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts, "Remove workspace folder")

    -- Show diagnostics in a floating window
    nnoremap('gl', vim.diagnostic.open_float, bufopts)
    -- Move to the previous diagnostic
    nnoremap('[d', vim.diagnostic.goto_prev, bufopts)
    -- Move to the next diagnostic
    nnoremap(']d', vim.diagnostic.goto_next, bufopts)
end

M.on_attach = on_attach

M.on_attach_java = function(client, bufnr)
    local jdtls = require('jdtls')
    local jdtls_setup = require('jdtls.setup')

    -- Regular Neovim LSP client keymappings
    on_attach(client, bufnr)

    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- Java extensions provided by jdtls
    nnoremap("<leader>o", jdtls.organize_imports, bufopts, "Organize imports")
    nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
    nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
    vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
        { noremap = true, silent = true, buffer = bufnr, desc = "Extract method" })

    jdtls.setup_dap({ hotcodereplace = 'auto' })
    jdtls_setup.add_commands()
    require("dapui").setup()
end

M.setup = function()
    local lsp_zero = require('lsp-zero')

    lsp_zero.ensure_installed({
        'gopls',
        'jdtls',
        'pyright',
        'rust_analyzer',
        'lua_ls',
        'tsserver',
    })

    vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

    lsp_zero.preset('lsp-only')
    lsp_zero.skip_server_setup({ "jdtls" })
    lsp_zero.nvim_workspace({
        library = vim.api.nvim_get_runtime_file('', true)
    })
    --[[ local lua_opts = lsp_zero.defaults.nvim_workspace()
    lua_opts.settings.Lua.completion = { callSnippet = 'Replace' }
    lua_opts.settings.Lua.library = vim.api.nvim_get_runtime_file('', true)
    lsp_zero.configure('sumneko_lua', lua_opts) ]]
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
    }

    lsp_zero.set_preferences({
        capabilities = capabilities,
        set_lsp_keymaps = false,
    })
    lsp_zero.on_attach(on_attach)
    lsp_zero.setup()
end

return M
