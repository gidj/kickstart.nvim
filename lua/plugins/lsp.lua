return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local null_ls = require("null-ls")
      local sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.prettier.with({ filtetypes = { "json" } }),
      }
      require "null-ls".setup({
        sources = sources,
        -- debug = true,
      })
    end
  },
}
-- vim: ts=2 sts=2 sw=2 et
