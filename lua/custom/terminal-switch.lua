-- Remember last-used terminal buffer + its preferred width
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  callback = function(args)
    local buf = args.buf
    if vim.bo[buf].buftype == "terminal" then
      vim.g._last_term_buf = buf
    end
  end,
})

local function is_term_buf(buf) return vim.bo[buf].buftype == "terminal" end

local function exit_term_mode()
  local keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end

local function find_window_showing_buf(bufnr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
  return nil
end

local function set_term_window_prefs(win, width)
  -- Prefer it on the right; keep width stable if other splits change
  pcall(function() vim.api.nvim_win_set_option(win, "winfixwidth", true) end)
  if width and width > 0 then
    vim.api.nvim_win_set_width(win, width)
  end
end

local function open_last_term_in_vert_split()
  local target = vim.g._last_term_buf
  if target and vim.api.nvim_buf_is_valid(target) then
    local win = find_window_showing_buf(target)
    if win then
      -- Already visible: jump there and normalize width
      vim.api.nvim_set_current_win(win)
      set_term_window_prefs(win, vim.b[target]._saved_term_width)
      return
    end
    -- Not visible: open in a right split and restore width
    vim.opt.splitright = true
    vim.cmd("vert sbuffer " .. target)
    local curwin = vim.api.nvim_get_current_win()
    set_term_window_prefs(curwin, vim.b[target]._saved_term_width)
  else
    -- First time: create a terminal on the right, no saved width yet
    vim.opt.splitright = true
    vim.cmd("vsplit")
    vim.cmd("term")
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    set_term_window_prefs(win, vim.b[buf]._saved_term_width)
  end
end

local function toggle_terminal_vert()
  local curbuf = vim.api.nvim_get_current_buf()
  if is_term_buf(curbuf) then
    -- Save current width on the buffer, then hide the window
    local win = vim.api.nvim_get_current_win()
    local width = vim.api.nvim_win_get_width(win)
    vim.b[curbuf]._saved_term_width = width
    -- allow width to change in other windows after we hide
    pcall(function() vim.api.nvim_win_set_option(win, "winfixwidth", false) end)
    vim.cmd("hide")
  else
    open_last_term_in_vert_split()
  end
end

-- Normal mode: Ctrl+\
vim.keymap.set("n", "<C-\\>", toggle_terminal_vert, { desc = "Toggle last terminal (vertical)" })

-- Terminal mode: Ctrl+\
vim.keymap.set("t", "<C-\\>", function()
  exit_term_mode()
  vim.schedule(toggle_terminal_vert)
end, { desc = "Toggle last terminal (vertical)" })

