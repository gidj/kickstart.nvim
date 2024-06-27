local home = os.getenv 'HOME'
local jdtls = require 'jdtls'
local mason_registry = require 'mason-registry'

local jdtls_path = mason_registry.get_package('jdtls'):get_install_path()
local java_debug_path = mason_registry.get_package('java-debug-adapter'):get_install_path()
local java_test_path = mason_registry.get_package('java-test'):get_install_path()

-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
-- local root_markers = { 'gradlew', 'build.gradle', 'mvnw', '.git' }
local root_markers = { "packageInfo" }
local root_dir = require('jdtls.setup').find_root(root_markers)

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
os.execute('mkdir ' .. workspace_folder)

local operating_system
if vim.fn.has 'macunix' then
  operating_system = 'mac'
elseif vim.fn.has 'win32' then
  operating_system = 'win'
else
  operating_system = 'linux'
end

local lsp_config = require 'config/lsp'

local bundles = {
  -- vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1)
  vim.fn.glob(home .. '/projects/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar', 1),
}
-- This is the new part
-- vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. '/projects/vscode-java-test/server/*.jar', 1), '\n'))

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' },
}

local config = {
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 80,
  },
  on_attach = lsp_config.on_attach_java, -- This is just another module of mine, not `lspconfig`
  root_dir = root_dir, -- Essentially this: https://w.amazon.com/bin/view/Bemol/#HnvimbuiltinLSP
  settings = {
    java = {
      signatureHelp = { enabled = true },
      inlayhints = {
        parameterNames = {
          enabled = true,
        },
      },
      -- format = {
      --   settings = {
      --   },
      -- },
      contentProvider = { preferred = 'fernflower' },  -- Use fernflower to decompile library code
      completion = {
        favoriteStaticMembers = {
          'org.hamcrest.MatcherAssert.assertThat',
          'org.hamcrest.Matchers.*',
          'org.hamcrest.CoreMatchers.*',
          'org.junit.jupiter.api.Assertions.*',
          'java.util.Objects.requireNonNull',
          'java.util.Objects.requireNonNullElse',
          'org.mockito.Mockito.*',
        },
        filteredTypes = {
          'com.sun.*',
          'io.micrometer.shaded.*',
          'java.awt.*',
          'jdk.*',
          'sun.*',
        },
      },
      -- Specify any options for organizing imports
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      -- How code generation should act
      codeGeneration = {
        toString = {
          template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
        },
        useBlocks = true,
      },
      configuration = {
        runtimes = {
          {
            name = 'JavaSE-1.8',
            path = home .. '/.local/share/mise/installs/java/corretto-8.392.08.1',
            default = true,
          },
          {
            name = 'JavaSE-17',
            path = home .. '/.local/share/mise/installs/java/openjdk-17',
          },
          {
            name = 'JavaSE-19',
            path = home .. '/.local/share/mise/installs/java/openjdk-19',
          },
        },
      },
    },
  },
  cmd = {
    home .. '/.local/share/mise/installs/java/openjdk-19/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    -- If you use lombok, download the lombok jar and place it in ~/.local/share/eclipse
    '-javaagent:'
      .. home
      .. '/.local/share/eclipse/lombok-edge.jar',

    -- The jar file is located where jdtls was installed. This will need to be updated
    -- to the location where you installed jdtls
    '-jar',
    vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),

    -- The configuration for jdtls is also placed where jdtls was installed. This will
    -- need to be updated depending on your environment
    '-configuration',
    jdtls_path .. '/config_' .. operating_system,

    -- Use the workspace_folder defined above to store data for this project
    '-data',
    workspace_folder,
  },
  init_options = {
    bundles = bundles,
    workspaceFolders = require('util.lsp').java_workspaces(),
  },
}
local extendedClientCapabilities = require('jdtls').extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
extendedClientCapabilities.onCompletionItemSelectedCommand = "editor.action.triggerParameterHints"
config.init_options = {
  bundles = bundles,
  workspaceFolders = require('util.lsp').java_workspaces(),
  extendedClientCapabilities = extendedClientCapabilities,
}

local M = {}

M.setup = function()
  jdtls.start_or_attach(config)
end

return M
