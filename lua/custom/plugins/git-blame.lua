return {
  {
    'f-person/git-blame.nvim',
    event = 'bufRead',
    config = function()
      vim.cmd 'highlight default link gitblame SpecialComment'
      vim.g.gitblame_enabled = 1
    end,
  },
}
