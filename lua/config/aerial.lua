-- Aerial configuration (file outline)

require('aerial').setup({
  -- Priority list of preferred backends for aerial
  backends = { "treesitter", "lsp", "markdown", "man" },
  
  -- Show box drawing characters for the tree hierarchy
  show_guides = true,
  
  -- Run this command after jumping to a symbol
  post_jump_cmd = "normal! zz",
  
  -- When true, aerial will automatically close after jumping to a symbol
  close_on_select = false,
  
  -- Options for the LSP backend
  lsp = {
    -- Fetch document symbols when LSP diagnostics update
    diagnostics_trigger_update = true,
    -- Set to false to not update the symbols when there are LSP errors
    update_when_errors = true,
  },
})

