local servers =
{
  'gopls',
  'jdtls',
  'pyright',
  'rust_analyzer',
  'lua_ls',
  'tsserver',
}

local lsp_config = require("config/lsp")

return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = "v3.x",
    dependencies = {
      'neovim/nvim-lspconfig',
      { 'williamboman/mason.nvim', build = ":MasonUpdate" },
      'williamboman/mason-lspconfig.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {},
        branch = "legacy"
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')

      local lspconfig = require 'lspconfig'
      local configs = require 'lspconfig.configs'


      vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

      -- Check if the config is already defined (useful when reloading this file)
      if not configs.barium then
        configs.barium = {
          default_config = {
            cmd = { 'barium' },
            filetypes = { 'brazilconfig' },
            root_dir = function(fname)
              return lspconfig.util.find_git_ancestor(fname)
            end,
            settings = {},
          },
        }
      end

      lspconfig.barium.setup {}

      mason.setup({})
      mason_lspconfig.setup({
        ensure_installed = servers,
        handlers = {
          lsp_zero.default_setup,
          jdtls = lsp_zero.noop,
          lua_ls = function ()
            local lua_opts = lsp_zero.nvim_lua_ls()
            lspconfig.lua_ls.setup(lua_opts)
          end,
        }
      })

      lsp_zero.preset('lsp-only')

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" }
      }

      lsp_zero.set_preferences({
        capabilities = capabilities,
        set_lsp_keymaps = false,
      })
      lsp_zero.on_attach(lsp_config.on_attach)
      lsp_zero.setup()
      -- Setup neovim lua configuration
      require('neodev').setup()
    end
  }
}
