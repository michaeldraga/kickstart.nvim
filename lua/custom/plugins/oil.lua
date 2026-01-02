return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    init = function()
      vim.keymap.set('n', '<leader>-', function()
        require('oil').open(vim.fn.expand '%:p:h')
      end, { desc = 'Oil: open current file directory' })

      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          local argv = vim.fn.argv(0)
          if argv == '' then
            return
          end

          local stat = vim.uv.fs_stat(argv)
          if not stat or stat.type ~= 'directory' then
            return
          end

          -- Avoid interfering if user opened a file or some plugin already set a buffer
          if vim.api.nvim_buf_get_name(0) ~= '' then
            return
          end

          -- Open Oil at exactly that dir (CWD if `.`)
          require('oil').open(argv)
        end,
      })
    end,
    opts = {
      default_file_explorer = true, -- Oil takes over directory buffers
      columns = { 'icon', 'size', 'mtime' }, -- add "permissions" if you like
      view_options = { show_hidden = true },
      keymaps = {
        ['q'] = 'actions.close',
        ['-'] = 'actions.parent',
        ['<CR>'] = 'actions.select',
        ['<C-v>'] = 'actions.select_vsplit',
        ['<C-s>'] = 'actions.select_split',
        ['<C-t>'] = 'actions.select_tab',
        ['<C-h>'] = false,
        ['<C-j>'] = false,
        ['<C-k>'] = false,
        ['<C-l>'] = false,
        ['gr'] = 'actions.refresh',
      },
      float = {
        padding = 4,
        border = 'rounded',
        max_width = 0.8,
      },
    },
    keys = {
      {
        '-',
        function()
          require('oil').open()
        end,
        desc = 'Oil: open parent directory',
      },
      {
        '<leader>o',
        function()
          require('oil').open_float()
        end,
        desc = 'Oil: float here',
      },
    },
  },
}
