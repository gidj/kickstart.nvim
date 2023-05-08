return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  'justinmk/vim-dirvish',
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim"
    },
    cmd = "Neotree",
    keys = {
      { "<C-b>", "<cmd>Neotree toggle<cr>", mode = "n", desc = "Toggle Neotree" },
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = true,
        }
      })
    end
  },
  { 'mfussenegger/nvim-jdtls' },
  {
    "windwp/nvim-autopairs",
    opts = {}
  },
  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',   opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
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
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {}
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
  {
    'kevinhwang91/nvim-bqf',
  },
  {
    'mechatroner/rainbow_csv',
  },
  {
    'scalameta/nvim-metals',
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    -- config = function()
    --   local metals_config = require("metals").bare_config()
    --
    --   -- Example of settings
    --   metals_config.settings = {
    --     showImplicitArguments = true,
    --     excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
    --   }
    --
    --   -- *READ THIS*
    --   -- I *highly* recommend setting statusBarProvider to true, however if you do,
    --   -- you *have* to have a setting to display this in your statusline or else
    --   -- you'll not see any messages from metals. There is more info in the help
    --   -- docs about this
    --   -- metals_config.init_options.statusBarProvider = "on"
    --
    --   -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
    --   metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
    --
    --   -- Debug settings if you're using nvim-dap
    --   -- local dap = require("dap")
    --   --
    --   -- dap.configurations.scala = {
    --   --   {
    --   --     type = "scala",
    --   --     request = "launch",
    --   --     name = "RunOrTest",
    --   --     metals = {
    --   --       runType = "runOrTestFile",
    --   --       --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    --   --     },
    --   --   },
    --   --   {
    --   --     type = "scala",
    --   --     request = "launch",
    --   --     name = "Test Target",
    --   --     metals = {
    --   --       runType = "testTarget",
    --   --     },
    --   --   },
    --   -- }
    --
    --   metals_config.on_attach = function(client, bufnr)
    --     require("metals").setup_dap()
    --   end
    --
    --   -- Autocmd that will actually be in charging of starting the whole thing
    --   local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    --   vim.api.nvim_create_autocmd("FileType", {
    --     -- NOTE: You may or may not want java included here. You will need it if you
    --     -- want basic Java support but it may also conflict if you are using
    --     -- something like nvim-jdtls which also works on a java filetype autocmd.
    --     pattern = {
    --       "scala",
    --       "sbt",
    --       "java",
    --     },
    --     callback = function()
    --       require("metals").initialize_or_attach(metals_config)
    --     end,
    --     group = nvim_metals_group,
    --   })
    -- end
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
  --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
}
