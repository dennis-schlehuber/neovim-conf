local overseer = require("overseer")

overseer.setup({
  task_list = {
    direction = "bottom",
    min_height = 12,
    default_detail = 1,
  },
})

-- Overseer ships templates for cargo/npm/make/etc. but not Gradle, so register
-- one that drives the project's ./gradlew wrapper (falling back to a system
-- gradle on $PATH). This gives an IntelliJ-ish "pick a task and run it" flow.
local GRADLE_ROOT_MARKERS = {
  "gradlew",
  "settings.gradle",
  "settings.gradle.kts",
  "build.gradle",
  "build.gradle.kts",
}

local function gradle_root()
  return vim.fs.root(0, GRADLE_ROOT_MARKERS)
end

overseer.register_template({
  name = "gradle",
  desc = "Run a Gradle task (build, test, bootRun, ...)",
  params = {
    args = {
      type = "list",
      delimiter = " ",
      desc = "Gradle tasks/args",
      default = { "build" },
    },
  },
  condition = {
    callback = function()
      return gradle_root() ~= nil
    end,
  },
  builder = function(params)
    local root = gradle_root()
    local cmd = { "gradle" }
    if root and vim.fn.filereadable(root .. "/gradlew") == 1 then
      cmd = { root .. "/gradlew" }
    end
    return {
      cmd = cmd,
      args = params.args,
      cwd = root,
      components = { "default" },
    }
  end,
})

-- Task-runner keymaps live under the <leader>r ("run") prefix alongside the
-- existing uv-run / refactor bindings.
vim.keymap.set("n", "<leader>rt", "<cmd>OverseerToggle<CR>", { desc = "Overseer: Toggle task list" })
vim.keymap.set("n", "<leader>ra", "<cmd>OverseerRun<CR>", { desc = "Overseer: Run task" })
vim.keymap.set("n", "<leader>rq", "<cmd>OverseerQuickAction<CR>", { desc = "Overseer: Quick action" })
vim.keymap.set("n", "<leader>ri", "<cmd>OverseerInfo<CR>", { desc = "Overseer: Info" })
