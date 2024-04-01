return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "rcasia/neotest-java",
      "nvim-neotest/neotest-python"
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require("neotest-java")({
            ignore_wrapper = true,
          }),
          require("neotest-python")
        },
        -- strategy = "dap"
      })
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  }
}
