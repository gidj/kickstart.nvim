-- Fuzzy Finder (files, lsp, etc)
-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`

-- TODO: move all telescope stuff to module
-- require('config/telescope').setup()

-- Enable telescope fzf native, if installed

return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies =
    {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'debugloop/telescope-undo.nvim',
    },
    config = function()
      local actions = require('telescope.actions')
      local telescope = require("telescope")

      telescope.setup {
        defaults = {
          mappings = {
            n = {
              ["q"] = actions.close
            },
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ["<esc>"] = actions.close
            },
          },
        },
        extensions = {
          -- file_browser = {
          --   theme = "ivy",
          --   -- disables netrw and use telescope-file-browser in its place
          --   hijack_netrw = true,
          --   --[[ mappings = {
          --           ["i"] = {
          --               -- your custom insert mode mappings
          --           },
          --           ["n"] = {
          --               -- your custom normal mode mappings
          --           },
          --       }, ]]
          -- },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          -- ['ui-select'] = {
          --   require('telescope.themes').get_dropdown {
          --
          --   }
          -- },
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            }
          }
        }
      }

      -- telescope.load_extension('file_browser')
      -- telescope.load_extension('ui-select')
      telescope.load_extension('undo')
      pcall(require('telescope').load_extension, 'fzf')
    end
  },
  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
