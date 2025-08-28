return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for git operations
  },
  config = function()
    require('claude-code').setup {
      window = {
        position = 'vertical',
      },
      keymaps = {
        toggle = {
          normal = '<leader>co',
        },
      },
      git = {
        use_git_root = false,
      },
    }
  end,
}
