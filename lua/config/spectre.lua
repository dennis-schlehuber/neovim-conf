local spectre = require("spectre")

spectre.setup({
  open_cmd = "noswapfile vnew",
  highlight = {
    ui = "String",
    search = "DiffChange",
    replace = "DiffDelete",
  },
  mapping = {
    ["toggle_line"] = {
      map = "dd",
      cmd = "<cmd>lua require('spectre').toggle_line()<cr>",
      desc = "toggle item",
    },
    ["enter_file"] = {
      map = "<cr>",
      cmd = "<cmd>lua require('spectre.actions').select_entry()<cr>",
      desc = "open file",
    },
    ["run_current_replace"] = {
      map = "<leader>rc",
      cmd = "<cmd>lua require('spectre.actions').run_current_replace()<cr>",
      desc = "replace current line",
    },
    ["run_replace"] = {
      map = "<leader>R",
      cmd = "<cmd>lua require('spectre.actions').run_replace()<cr>",
      desc = "replace all",
    },
    ["toggle_ignore_case"] = {
      map = "ti",
      cmd = "<cmd>lua require('spectre').change_options('ignore-case')<cr>",
      desc = "toggle ignore case",
    },
    ["toggle_ignore_hidden"] = {
      map = "th",
      cmd = "<cmd>lua require('spectre').change_options('hidden')<cr>",
      desc = "toggle hidden files",
    },
  },
})

vim.keymap.set("n", "<leader>wt", function() spectre.toggle() end, { desc = "Spectre: Toggle" })
vim.keymap.set("n", "<leader>ww", function() spectre.open_word_search() end, { desc = "Spectre: Search word" })
vim.keymap.set("n", "<leader>wf", function() spectre.open_file_search() end, { desc = "Spectre: Search in file" })
