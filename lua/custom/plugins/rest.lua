return {
  {
    'rest-nvim/rest.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, 'http')
      end,
      config = function()
        vim.keymap.set('n', '<leader>rs', '<cmd>Rest run<CR>', { desc = '[R]est [S]tart' })
        vim.keymap.set('n', '<leader>ro', '<cmd>Rest open<CR>', { desc = '[R]est [O]pen results pane' })
        vim.keymap.set('n', '<leader>rl', '<cmd>Rest logs<CR>', { desc = '[R]est [L]ogs' })
        vim.keymap.set('n', '<leader>rec', '<cmd>Rest logs<CR>', { desc = '[R]est [E]nvironment [C]urrent' })
        vim.keymap.set('n', '<leader>res', '<cmd>Rest logs<CR>', { desc = '[R]est [E]nvironment [S]elect' })

        vim.api.nvim_create_autocmd('User', {
          pattern = 'RestResponsePre',
          callback = function()
            ---@type { body: string, headers: table<string, string[]>, statistics: { size_download: string, time_total: string }, status: { code: number, text: string, version: string } }
            ---@diagnostic disable-next-line: undefined-field
            local res = _G.rest_response

            if res.body:match '^%s*{%s*.*}%s*$' then
              -- Only if jq is available
              if vim.fn.executable 'jq' == 0 then
                return
              end
              -- Wrap vim.cmd in a function to avoid the param-type error
              pcall(function()
                res.body = vim.fn.system('jq', res.body)
              end)

              -- Force filetype so highlighting kicks in
              -- vim.api.nvim_set_option_value('filetype', 'json', { buf = ev.buf })
            end
          end,
        })
      end,
    },
  },
}
