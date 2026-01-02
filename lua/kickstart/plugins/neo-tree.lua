-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local function is_oil_buffer()
  local name = vim.api.nvim_buf_get_name(0)
  return name:match '^oil://' ~= nil
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    'mrbjarksen/neo-tree-diagnostics.nvim', -- ← adds the `diagnostics` source
  },
  setup = function()
    vim.keymap.set('n', '<leader>er', ':Neotree reveal left<CR>', { desc = 'Neo-tree: reveal file' })
  end,
  lazy = false,
  keys = {
    {
      '\\',
      function()
        if is_oil_buffer() then
          vim.cmd 'Neotree toggle left filesystem reveal=false'
          return
        end
        -- Toggle Neo-tree filesystem
        vim.cmd 'Neotree toggle left filesystem reveal=true'
      end,
      { desc = 'Neo-tree: filesystem' },
    },
    -- { '\\', ':Neotree reveal toggle<CR>', { desc = 'Neo-tree: filesystem' } },
    -- { '<leader>e', ':Neotree toggle left filesystem<CR>', desc = 'Neo-tree: filesystem' },
    { '<leader>eg', ':Neotree toggle left git_status<CR>', desc = 'Neo-tree: git status' },
    { '<leader>ed', ':Neotree toggle left diagnostics<CR>', desc = 'Neo-tree: diagnostics' },
    { '<leader>es', ':Neotree document_symbols reveal float<CR>', desc = 'Neo-tree: symbols (float)' },
  },
  opts = {
    filesystem = {
      hijack_netrw_behavior = 'disabled',
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    sources = { 'filesystem', 'git_status', 'document_symbols', 'diagnostics' },
    default_component_configs = {
      git_status = {
        symbols = {
          -- Change type
          added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = '✖', -- this can only be used in the git_status source
          renamed = '󰁕', -- this can only be used in the git_status source
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
      },
    },
  },
}
