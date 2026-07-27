local PREFIX = "<leader>l"
local function map(key, action, opts, mode)
    mode = mode or "n"
    vim.keymap.set(mode, PREFIX..key, action, vim.tbl_extend('force', { noremap = true, silent = true }, opts))
end


-- colors
-- FIXME: make matches more prominent
local hl_colors = vim.api.nvim_get_hl(0, { name="CursorLine"})



-- Diagnostics Mappings
local prefix_bak = PREFIX
PREFIX = ""
map('<leader>dd', vim.diagnostic.open_float, { desc = "Open diagnostics (float)" })
map('[d',         vim.diagnostic.goto_prev,  { desc = "Go to previous diagnostic" })
map(']d',         vim.diagnostic.goto_next,  { desc = "Go to next diagnostic" })
map('<space>q',   vim.diagnostic.setloclist, { desc = "Put diagnostics in lication list" })
PREFIX = prefix_bak



vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- configure reference highlights
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_set_hl(0, "LspReferenceRead",  hl_colors)
        vim.api.nvim_set_hl(0, "LspReferenceText",  hl_colors)
        vim.api.nvim_set_hl(0, "LspReferenceWrite", hl_colors)

        vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false
        })
        vim.api.nvim_clear_autocmds({
            group = 'lsp_document_highlight',
            buffer = bufnr,
        })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    -- Mappings
    -- FIXME: only if in a different file
    map('C', vim.lsp.buf.incoming_calls,   { buffer = bufnr, desc = "LSP: Incoming calls" })
    map('H', vim.lsp.buf.signature_help,   { buffer = bufnr, desc = "LSP: Signature help" })
    map('S', vim.lsp.buf.workspace_symbol, { buffer = bufnr, desc = "LSP: Workspace symbol" })
    map('a', vim.lsp.buf.code_action,      { buffer = bufnr, desc = "LSP: Code action" })
    map('c', vim.lsp.buf.outgoing_calls,   { buffer = bufnr, desc = "LSP: Outgoing calls" })
    map('f', vim.lsp.buf.references,       { buffer = bufnr, desc = "LSP: References" })
    map('h', vim.lsp.buf.hover,            { buffer = bufnr, desc = "LSP: Hover" })
    map('i', vim.lsp.buf.implementation,   { buffer = bufnr, desc = "LSP: Implementation" })
    map('s', vim.lsp.buf.document_symbol,  { buffer = bufnr, desc = "LSP: Document symbol" })
    map('t', vim.lsp.buf.type_definition,  { buffer = bufnr, desc = "LSP: Type definition" })

    -- Refactoring mappings
    map('F', function() vim.lsp.buf.format { async = true } end, { buffer = bufnr, desc = "LSP: Format file" })
    map('r', vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP: Rename" })

    -- Workspace mappings
    map('L', vim.lsp.buf.list_workspace_folders, { buffer = bufnr, desc = "LSP: List workspace folders" })
    map('N', vim.lsp.buf.add_workspace_folder, { buffer = bufnr, desc = "LSP: Add workspace folder" })
    map('R', vim.lsp.buf.remove_workspace_folder, { buffer = bufnr, desc = "LSP: Remove workspace folder" })

    local prefix_bak = PREFIX
    PREFIX = ""
    map('gd', vim.lsp.buf.definition,  { buffer = bufnr, desc = "LSP: Definition" })
    map('gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = "LSP: Declaration" })
    PREFIX = prefix_bak
  end
})



-- configure hover windows
local border =  {
    {"┌", "FloatBorder"},
    {"─", "FloatBorder"},
    {"┐", "FloatBorder"},
    {"│", "FloatBorder"},
    {"┘", "FloatBorder"},
    {"─", "FloatBorder"},
    {"└", "FloatBorder"},
    {"│", "FloatBorder"},
}

vim.api.nvim_set_hl(0, "NormalFloat", hl_colors )
vim.api.nvim_set_hl(0, "FloatBorder", hl_colors)
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end



vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
        },
    },
})



-- IMPORTANT: this has to be in this order and before lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
    -- ensure_installed = {
        -- 'cssls',
        -- 'eslint',
        -- 'html',
        -- 'lua_ls',
        -- 'pylsp',
        -- 'ts_ls',
        -- 'groovyls',
        -- 'dockerls',
        -- 'docker_compose_language_service',
        -- 'bashls',
    -- },
    handlers = {
        ['pylsp'] = function()
            vim.lsp.config('pylsp', {
                settings = {
                    pylsp = {
                        plugins = {
                            pylint = { enabled = true, executable = "pylint" },
                        }
                    }
                }
            })
        end,
      }
})

-- Do this, because otherwise the LSP server doesn't start...
vim.api.nvim_exec_autocmds("FileType", {})
