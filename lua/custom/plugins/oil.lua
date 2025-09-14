return {
  {
    'stevearc/oil.nvim',
    setup = function()
      vim.keymap.set('n', '<leader>-', function()
        require('oil').open(vim.fn.expand '%:p:h')
      end, { desc = 'Oil: open current file directory' })
    end,
    opts = {
      default_file_explorer = true, -- Oil takes over directory buffers
      columns = { 'icon', 'size', 'mtime' }, -- add "permissions" if you like
      view_options = { show_hidden = true },
      keymaps = {
        ['q'] = 'actions.close',
        ['-'] = 'actions.parent',
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = 'actions.select_vsplit',
        ['<C-h>'] = 'actions.select_split',
        ['<C-t>'] = 'actions.select_tab',
        ['gr'] = 'actions.refresh',
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
