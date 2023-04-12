local M = {}
M.setup = function()
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
end

return M
