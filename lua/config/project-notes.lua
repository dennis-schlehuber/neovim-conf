local M = {}

local notes_dir = vim.fn.stdpath("data") .. "/project-notes"
local SIGN_GROUP = "ProjectNotes"
local SIGN_NAME  = "ProjectNotesSign"

-- Register sign once
vim.fn.sign_define(SIGN_NAME, { text = "󰎞", texthl = "DiagnosticHint" })

local function get_project_root()
  local bufpath = vim.fn.expand("%:p:h")
  if bufpath == "" then bufpath = vim.fn.getcwd() end
  local result = vim.fn.systemlist("git -C " .. vim.fn.shellescape(bufpath) .. " rev-parse --show-toplevel")
  if vim.v.shell_error == 0 and result[1] and result[1] ~= "" then
    return result[1]
  end
  return vim.fn.getcwd()
end

local function sanitize_path(path)
  return path:gsub("^/", ""):gsub("/", "_") .. ".md"
end

local function get_note_path(root)
  return notes_dir .. "/" .. sanitize_path(root or get_project_root())
end

local function get_relative_path(root, filepath)
  if not filepath or filepath == "" then return nil end
  local escaped = root:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
  return filepath:match("^" .. escaped .. "/(.+)$")
end

-- Check whether a relative path has a header in the note file
local function has_note(note_path, rel_path)
  local f = io.open(note_path, "r")
  if not f then return false end
  local pattern = "^--- " .. rel_path:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1") .. " ---$"
  for line in f:lines() do
    if line:match(pattern) then
      f:close()
      return true
    end
  end
  f:close()
  return false
end

-- Place or clear the gutter sign for a buffer
local function refresh_sign(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.fn.sign_unplace(SIGN_GROUP, { buffer = bufnr })

  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then return end

  local root = get_project_root()
  local rel_path = get_relative_path(root, filepath)
  if not rel_path then return end

  local note_path = get_note_path(root)
  if has_note(note_path, rel_path) then
    vim.fn.sign_place(0, SIGN_GROUP, SIGN_NAME, bufnr, { lnum = 1, priority = 10 })
  end
end

-- Refresh signs for all loaded normal buffers (called after a header is inserted)
local function refresh_all_signs()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" then
      refresh_sign(bufnr)
    end
  end
end

-- Auto-refresh sign on buffer entry
vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
  group = vim.api.nvim_create_augroup("ProjectNotesSign", { clear = true }),
  callback = function(ev) refresh_sign(ev.buf) end,
})

-- Track open windows per note file to avoid duplicates
local open_windows = {}

function M.open()
  local project_root = get_project_root()
  local current_file = vim.fn.expand("%:p")
  local rel_path = get_relative_path(project_root, current_file)

  vim.fn.mkdir(notes_dir, "p")
  local note_path = get_note_path(project_root)

  -- Focus existing window if already open
  local existing = open_windows[note_path]
  if existing and vim.api.nvim_win_is_valid(existing) then
    vim.api.nvim_set_current_win(existing)
    return
  end

  local bufnr = vim.fn.bufnr(note_path)
  if bufnr == -1 then
    bufnr = vim.fn.bufadd(note_path)
  end
  vim.fn.bufload(bufnr)
  vim.bo[bufnr].filetype = "markdown"
  vim.bo[bufnr].bufhidden = "hide"

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.7)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Notes ",
    title_pos = "center",
  })

  open_windows[note_path] = win

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  vim.api.nvim_win_set_cursor(win, { line_count, 0 })

  local augroup = vim.api.nvim_create_augroup("ProjectNotes_" .. bufnr, { clear = true })

  local function save()
    if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modified then
      vim.api.nvim_buf_call(bufnr, function() vim.cmd("silent! write") end)
    end
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    group = augroup,
    buffer = bufnr,
    callback = save,
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    group = augroup,
    pattern = tostring(win),
    once = true,
    callback = function()
      open_windows[note_path] = nil
      save()
    end,
  })

  local function close()
    save()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.keymap.set("n", "q",     close, { buffer = bufnr, nowait = true, desc = "Close notes" })
  vim.keymap.set("n", "<Esc>", close, { buffer = bufnr, nowait = true, desc = "Close notes" })

  -- Insert header for the file that was open when notes were opened
  vim.keymap.set("n", "<leader>h", function()
    if not rel_path then
      vim.notify("No source file to reference", vim.log.levels.WARN)
      return
    end

    local timestamp = os.date("%Y-%m-%d %H:%M")
    local lc = vim.api.nvim_buf_line_count(bufnr)
    local last_line = vim.api.nvim_buf_get_lines(bufnr, lc - 1, lc, false)[1] or ""

    local lines = {}
    if lc > 1 or last_line ~= "" then
      table.insert(lines, "")
    end
    table.insert(lines, "--- " .. rel_path .. " ---")
    table.insert(lines, timestamp)
    table.insert(lines, "")

    vim.api.nvim_buf_set_lines(bufnr, lc, lc, false, lines)
    vim.api.nvim_win_set_cursor(win, { lc + #lines, 0 })
    vim.cmd("startinsert")

    -- Immediately show the sign on the source buffer
    save()
    refresh_all_signs()
  end, { buffer = bufnr, nowait = true, desc = "Insert file header + timestamp" })
end

return M
