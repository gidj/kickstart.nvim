return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "rcasia/neotest-java"
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require("neotest-java")({
          ignore_wrapper = true,
        })
      },
      -- strategy = "dap"
    })
  end
}
