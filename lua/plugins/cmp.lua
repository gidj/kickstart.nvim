local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-emoji',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-path',
    'onsails/lspkind-nvim', -- Enables icons on completions

    -- Snippets
    {
      'L3MON4D3/LuaSnip',
      version = "v2.*",
      build = "make install_jsregexp"
    },
    'rafamadriz/friendly-snippets',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require('cmp')
    local lsp = require('lsp-zero')
    local lspkind = require 'lspkind'
    local luasnip = require('luasnip')

    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')

    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )

    local cmp_config = lsp.defaults.cmp_config({
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local kind = lspkind.cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry,
            vim_item)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          kind.kind = strings[1] .. " "
          kind.menu = " " .. strings[2]
          return kind
        end
      },
      mapping = lsp.defaults.cmp_mappings({
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ["<C-j>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" })
      }),
      sorting = {
        comparators = {
          cmp.config.compare.locality,
          cmp.config.compare.recently_used,
          cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
          cmp.config.compare.offset,
          cmp.config.compare.order,
        }
      },
      sources = {
        {
          name = 'luasnip',
          options = {
            use_show_condition = false,
            show_autosnippets = true
          }
        },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'nvim_lua' },
        {
          name = 'buffer',
          options = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end
          }
        },
        { name = 'path' },
      },
      view = { entries = { name = "custom", selection_order = "near_cursor" } },
      -- window = {
      -- 	completion = {
      -- 		winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      -- 		col_offset = -3,
      -- 		side_padding = 0
      -- 	}
      -- },
      window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
        --   winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None'
        -- }),
      },
      --[[ window = {
        completion = cmp.config.window.bordered()
    } ]]
    })

    cmp.setup(cmp_config)
  end
}
-- vim: ts=2 sts=2 sw=2 et
