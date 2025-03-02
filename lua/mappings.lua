require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- map({ "n" }, "-", "<cmd>Oil <cr>")
map({ "n" }, "<leader>fp", "<cmd>Telescope projects<cr>")
map({ "n" }, "<leader>fB", "<cmd>Telescope bookmarks<cr>")
map({ "n", "t" }, "<a-l>",
  function() require("nvchad.term").toggle { pos = "float", id = "lazygit", cmd = "lazygit", } end,
  { desc = "Toggle floating LazyGit window" })

map({ "n", "t" }, "<a-a>",
  function() require("nvchad.term").toggle { pos = "sp", id = "aider", cmd = "aider", } end,
  { desc = "Aider✨" })

vim.api.nvim_create_autocmd("TermClose", {
  callback = function()
    vim.api.nvim_input("<CR>")
  end,
})
