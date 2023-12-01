return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
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
}
