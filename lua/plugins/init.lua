local get_amazon_type_url = function(url_data)
  local url = 'https://'
    .. url_data.host:gsub('git', 'code')
    .. '/'
    .. url_data.repo:gsub('pkg', 'packages')
    .. '/blobs/'
    .. url_data.rev
    .. '/--/'
    .. url_data.file
  if url_data.lstart then
    url = url .. '#L' .. url_data.lstart
    if url_data.lend then
      url = url .. '-L' .. url_data.lend
    end
  end
  return url
end

return {
  -- Detect tabstop and shiftwidth automatically
  -- 'tpope/vim-sleuth',
  {
    'nmac427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup {
        filetype_exclude = {
          'java',
        },
      }
    end,
  },
  { 'RRethy/vim-illuminate' },
  -- {
  --   'echasnovski/mini.files',
  --   version = false,
  --   config = function ()
  --     require("mini.files").setup()
  --   end
  -- },
  'justinmk/vim-dirvish',
  'ipkiss42/xwiki.vim',
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim"
  --   },
  --   cmd = "Neotree",
  --   keys = {
  --     { "<C-b>", "<cmd>Neotree toggle<cr>", mode = "n", desc = "Toggle Neotree" },
  --   },
  --   config = function()
  --     require("neo-tree").setup({
  --       filesystem = {
  --         follow_current_file = true,
  --       }
  --     })
  --   end
  -- },
  { 'mfussenegger/nvim-jdtls' },
  { 'mfussenegger/nvim-dap' },
  { 'rcarriga/nvim-dap-ui' },
  {
    'windwp/nvim-autopairs',
    opts = {},
  },
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      _extmark_signs = false,
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
    },
  },
  {
    -- Theme inspired by Atom
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'tokyonight',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {},
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  -- {
  --   -- Add indentation guides even on blank lines
  --   'lukas-reineke/indent-blankline.nvim',
  --   -- Enable `lukas-reineke/indent-blankline.nvim`
  --   -- See `:help indent_blankline.txt`
  --   opts = {
  --     char = '┊',
  --     show_trailing_blankline_indent = false,
  --   },
  -- },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      require('mini.indentscope').setup()
      require('mini.surround').setup()
    end,
  },
  -- {
  --   "kylechui/nvim-surround",
  --   version = "*", -- Use for stability; omit to use `main` branch for the latest features
  --   event = "VeryLazy",
  --   config = function()
  --     require("nvim-surround").setup({
  --       -- Configuration here, or leave empty to use defaults
  --     })
  --   end
  -- },
  {
    'kevinhwang91/nvim-bqf',
  },
  {
    'mechatroner/rainbow_csv',
  },
  -- {
  --   'scalameta/nvim-metals',
  --   dependencies = {
  --     "nvim-lua/plenary.nvim"
  --   },
  --   -- config = function()
  --   --   local metals_config = require("metals").bare_config()
  --   --
  --   --   -- Example of settings
  --   --   metals_config.settings = {
  --   --     showImplicitArguments = true,
  --   --     excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
  --   --   }
  --   --
  --   --   -- *READ THIS*
  --   --   -- I *highly* recommend setting statusBarProvider to true, however if you do,
  --   --   -- you *have* to have a setting to display this in your statusline or else
  --   --   -- you'll not see any messages from metals. There is more info in the help
  --   --   -- docs about this
  --   --   -- metals_config.init_options.statusBarProvider = "on"
  --   --
  --   --   -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
  --   --   metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
  --   --
  --   --   -- Debug settings if you're using nvim-dap
  --   --   -- local dap = require("dap")
  --   --   --
  --   --   -- dap.configurations.scala = {
  --   --   --   {
  --   --   --     type = "scala",
  --   --   --     request = "launch",
  --   --   --     name = "RunOrTest",
  --   --   --     metals = {
  --   --   --       runType = "runOrTestFile",
  --   --   --       --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
  --   --   --     },
  --   --   --   },
  --   --   --   {
  --   --   --     type = "scala",
  --   --   --     request = "launch",
  --   --   --     name = "Test Target",
  --   --   --     metals = {
  --   --   --       runType = "testTarget",
  --   --   --     },
  --   --   --   },
  --   --   -- }
  --   --
  --   --   metals_config.on_attach = function(client, bufnr)
  --   --     require("metals").setup_dap()
  --   --   end
  --   --
  --   --   -- Autocmd that will actually be in charging of starting the whole thing
  --   --   local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
  --   --   vim.api.nvim_create_autocmd("FileType", {
  --   --     -- NOTE: You may or may not want java included here. You will need it if you
  --   --     -- want basic Java support but it may also conflict if you are using
  --   --     -- something like nvim-jdtls which also works on a java filetype autocmd.
  --   --     pattern = {
  --   --       "scala",
  --   --       "sbt",
  --   --       "java",
  --   --     },
  --   --     callback = function()
  --   --       require("metals").initialize_or_attach(metals_config)
  --   --     end,
  --   --     group = nvim_metals_group,
  --   --   })
  --   -- end
  -- },
  {
    'ruifm/gitlinker.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitlinker').setup {
        callbacks = {
          ['git.amazon.com'] = get_amazon_type_url,
        },
      }
    end,
  },
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = {
  --     "nvim-neotest/neotest-python",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "antoinemadec/FixCursorHold.nvim"
  --   },
  --   config = function()
  --     require("neotest").setup({
  --       adapters = {
  --         require("neotest-python")
  --       }
  --     })
  --   end
  -- },
  {
    'sindrets/diffview.nvim',
  },
  {
    'epwalsh/obsidian.nvim',
    event = { 'BufReadPre /Users/gideonva/obsidian/Amazon/**.md' },
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
    -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',

      -- Optional, for completion.
      'hrsh7th/nvim-cmp',

      -- Optional, for search and quick-switch functionality.
      'nvim-telescope/telescope.nvim',

      -- Optional, an alternative to telescope for search and quick-switch functionality.
      -- "ibhagwan/fzf-lua"

      -- Optional, another alternative to telescope for search and quick-switch functionality.
      -- "junegunn/fzf",
      -- "junegunn/fzf.vim"

      -- -- Optional, alternative to nvim-treesitter for syntax highlighting.
      -- "godlygeek/tabular",
      -- "preservim/vim-markdown",
    },
    opts = {
      dir = '~/obsidian/Amazon/', -- no need to call 'vim.fn.expand' here

      -- -- Optional, if you keep notes in a specific subdirectory of your vault.
      -- notes_subdir = "notes",

      -- -- Optional, set the log level for Obsidian. This is an integer corresponding to one of the log
      -- -- levels defined by "vim.log.levels.*" or nil, which is equivalent to DEBUG (1).
      -- log_level = vim.log.levels.DEBUG,

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = '__DAILY',
        -- -- Optional, if you want to change the date format for daily notes.
        -- date_format = "%Y-%m-%d"
      },

      -- Optional, completion.
      completion = {
        -- If using nvim-cmp, otherwise set to false
        nvim_cmp = true,
        -- Trigger completion at 2 chars
        min_chars = 2,
        -- Where to put new notes created from completion. Valid options are
        --  * "current_dir" - put new notes in same directory as the current buffer.
        --  * "notes_subdir" - put new notes in the default notes subdirectory.
        -- new_notes_location = "current_dir"
      },

      -- -- Optional, customize how names/IDs for new notes are created.
      -- note_id_func = function(title)
      --   -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      --   -- In this case a note with the title 'My new note' will given an ID that looks
      --   -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      --   local suffix = ""
      --   if title ~= nil then
      --     -- If title is given, transform it into valid file name.
      --     suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      --   else
      --     -- If title is nil, just add 4 random uppercase letters to the suffix.
      --     for _ = 1, 4 do
      --       suffix = suffix .. string.char(math.random(65, 90))
      --     end
      --   end
      --   return tostring(os.time()) .. "-" .. suffix
      -- end,

      -- -- Optional, set to true if you don't want Obsidian to manage frontmatter.
      -- disable_frontmatter = false,
      --
      -- -- Optional, alternatively you can customize the frontmatter data.
      -- note_frontmatter_func = function(note)
      --   -- This is equivalent to the default frontmatter function.
      --   local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      --   -- `note.metadata` contains any manually added fields in the frontmatter.
      --   -- So here we just make sure those fields are kept in the frontmatter.
      --   if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
      --     for k, v in pairs(note.metadata) do
      --       out[k] = v
      --     end
      --   end
      --   return out
      -- end,
      --
      -- -- Optional, for templates (see below).
      -- templates = {
      --   subdir = "templates",
      --   date_format = "%Y-%m-%d-%a",
      --   time_format = "%H:%M",
      -- },
      --
      -- -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- -- URL it will be ignored but you can customize this behavior here.
      -- follow_url_func = function(url)
      --   -- Open the URL in the default web browser.
      --   vim.fn.jobstart({ "open", url }) -- Mac OS
      --   -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- end,
      --
      -- -- Optional, set to true if you use the Obsidian Advanced URI plugin.
      -- -- https://github.com/Vinzent03/obsidian-advanced-uri
      -- use_advanced_uri = true,
      --
      -- -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      -- open_app_foreground = false,

      -- Optional, by default commands like `:ObsidianSearch` will attempt to use
      -- telescope.nvim, fzf-lua, and fzf.nvim (in that order), and use the
      -- first one they find. By setting this option to your preferred
      -- finder you can attempt it first. Note that if the specified finder
      -- is not installed, or if it the command does not support it, the
      -- remaining finders will be attempted in the original order.
      finder = 'telescope.nvim',
    },
    config = function(_, opts)
      require('obsidian').setup(opts)

      -- Optional, override the 'gf' keymap to utilize Obsidian's search functionality.
      -- see also: 'follow_url_func' config option above.
      vim.keymap.set('n', 'gf', function()
        if require('obsidian').util.cursor_on_markdown_link() then
          return '<cmd>ObsidianFollowLink<CR>'
        else
          return 'gf'
        end
      end, { noremap = false, expr = true })
    end,
  },
}
