-- local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
--
autocmd("Filetype", {
  pattern = "java",
  callback = function()
    require("config/java").setup()
  end
})

