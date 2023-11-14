--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
local LEADER = ','
vim.g.mapleader = LEADER
vim.g.maplocalleader = LEADER

-- Install package manager
--  https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup("plugins")

require('options')
require('keymaps')
require('autocmds')
