-- local stable_codelens = require 'custom.stable_codelens'
--
-- local function debounce(ms, fn)
--   local timer = vim.uv.new_timer()
--   return function(...)
--     local argv = { ... }
--     timer:stop()
--     timer:start(ms, 0, function()
--       vim.schedule(function()
--         fn(unpack(argv))
--       end)
--     end)
--   end
-- end
--
-- local function setup_codelens_refresh(client, bufnr)
--   if not client.supports_method 'textDocument/codeLens' then
--     return
--   end
--
--   -- Kill typescript-tools' CursorHold refresh
--   pcall(vim.api.nvim_clear_autocmds, { group = 'TypescriptToolsCodeLensGroup', buffer = bufnr })
--   pcall(vim.api.nvim_del_augroup_by_name, 'TypescriptToolsCodeLensGroup')
--
--   -- Clear builtin codelens namespace once (avoid any double-render if something triggers builtin refresh)
--   local builtin_ns = vim.lsp.codelens and vim.lsp.codelens._ns
--   if builtin_ns then
--     pcall(vim.api.nvim_buf_clear_namespace, bufnr, builtin_ns, 0, -1)
--   end
--
--   local refresh = debounce(500, function()
--     stable_codelens.refresh(bufnr)
--   end)
--
--   local function refresh_twice()
--     refresh()
--     vim.defer_fn(function()
--       refresh()
--     end, 800)
--   end
--
--   local group = vim.api.nvim_create_augroup('StableCodeLens_' .. bufnr, { clear = true })
--
--   -- Initial
--   refresh()
--
--   -- Refresh only on "settled" events
--   vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'DiagnosticChanged' }, {
--     group = group,
--     buffer = bufnr,
--     callback = refresh_twice,
--   })
--
--   -- On write: nudge tsserver project graph, then refresh
--   vim.api.nvim_create_autocmd('BufWritePost', {
--     group = group,
--     buffer = bufnr,
--     callback = function()
--       vim.defer_fn(refresh_twice, 200)
--     end,
--   })
-- end

return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      on_attach = function(client, bufnr)
        -- setup_codelens_refresh(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        jsx_close_tag = {
          enable = true,
          filetypes = { 'javascriptreact', 'typescriptreact' },
        },
        expose_as_code_action = 'all',
        code_lens = 'all', -- turn it back on so lenses exist
      },
    },
  },
}
