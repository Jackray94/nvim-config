require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd" }
})

--local on_attach = function(_, _) <--original
local on_attach = function(client, bufnr)
--------------------------------------------------------------------------
--  if client.server_capabilities.signatureHelpProvider then
--    require('lsp-overloads').setup(client, { })
--  end
--------------------------------------------------------------------------
  --- Guard against servers without the signatureHelper capability
  if client.server_capabilities.signatureHelpProvider then
    require('lsp-overloads').setup(client, {
        -- UI options are mostly the same as those passed to vim.lsp.util.open_floating_preview
        ui = {
          border = "single",           -- The border to use for the signature popup window. Accepts same border values as |nvim_open_win()|.
          height = nil,               -- Height of the signature popup window (nil allows dynamic sizing based on content of the help)
          width = nil,                -- Width of the signature popup window (nil allows dynamic sizing based on content of the help)
          wrap = true,                -- Wrap long lines
          wrap_at = nil,              -- Character to wrap at for computing height when wrap enabled
          max_width = nil,            -- Maximum signature popup width
          max_height = nil,           -- Maximum signature popup height
          -- Events that will close the signature popup window: use {"CursorMoved", "CursorMovedI", "InsertCharPre"} to hide the window when typing
          close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
          focusable = true,           -- Make the popup float focusable
          focus = false,              -- If focusable is also true, and this is set to true, navigating through overloads will focus into the popup window (probably not what you want)
          offset_x = 0,               -- Horizontal offset of the floating window relative to the cursor position
          offset_y = 0,                -- Vertical offset of the floating window relative to the cursor position
          floating_window_above_cur_line = false, -- Attempt to float the popup above the cursor position 
                                                 -- (note, if the height of the float would be greater than the space left above the cursor, it will default 
                                                 -- to placing the float below the cursor. The max_height option allows for finer tuning of this)
          silent = true,               -- Prevents noisy notifications (make false to help debug why signature isn't working)
          -- Highlight options is null by default, but this just shows an example of how it can be used to modify the LspSignatureActiveParameter highlight property
          highlight = {
            italic = true,
            bold = true,
            fg = "#ffffff",
--            ... -- Other options accepted by the `val` parameter of vim.api.nvim_set_hl()
          }
        },
        keymaps = {
          next_signature = "<C-j>",
          previous_signature = "<C-k>",
          next_parameter = "<C-l>",
          previous_parameter = "<C-h>",
          close_signature = "<C-;>"
        },
        display_automatically = true -- Uses trigger characters to automatically display the signature overloads when typing a method signature
      })
      vim.keymap.set("n", "<C-;>", ":LspOverloadsSignature<CR>", { noremap = true, silent = true, buffer = bufnr })
      vim.keymap.set("i", "<C-;>", "<cmd>LspOverloadsSignature<CR>", { noremap = true, silent = true, buffer = bufnr })

  end
--------------------------------------------------------------------------
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
  vim.keymap.set('n', 'gH', ":vsplit<CR>:ClangdSwitchSourceHeader<CR>", {})
  vim.keymap.set('n', 'gh', ":ClangdSwitchSourceHeader<CR>", {})
  vim.keymap.set('n', '<leader>ma', ":Telescope marks<CR>")
  vim.keymap.set('n', '<leader>kk', ":cprev<CR>")
  vim.keymap.set('n', '<leader>ll', ":cnext<CR>")


end


require'lspconfig'.clangd.setup{
  on_attach = on_attach,
  capabilities = capabilities
}
