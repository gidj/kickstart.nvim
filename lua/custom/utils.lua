local M = {}

function M.workspace_folders()
    local bemol_dir = vim.fs.find({ '.bemol' }, { upward = true, type = 'directory' })[1]
    local ws_folders_lsp = {}
    if bemol_dir then
        local file = io.open(bemol_dir .. '/ws_root_folders', 'r')
        if file then
            for line in file:lines() do
                table.insert(ws_folders_lsp, line)
            end
            file:close()
        end
    end
    return ws_folders_lsp
end

function M.lsp_workspaces()
    local dirs = M.workspace_folders()
    for _, line in ipairs(dirs) do
        vim.lsp.buf.add_workspace_folder(line)
    end
end

function M.java_workspaces()
    local workspaces = {}
    local dirs = M.workspace_folders()
    for _, dir in ipairs(dirs) do
        table.insert(workspaces, "file://" .. dir)
    end
    -- print(workspaces)
    return workspaces
end

return M
