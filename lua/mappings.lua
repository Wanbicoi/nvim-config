require "nvchad.mappings"

-- 🗑️ Disable mappings
local nomap = vim.keymap.del

nomap("n", "<tab>")
nomap("n", "<s-tab>")
nomap("n", "<leader>h")
nomap("n", "<leader>v")

-- add yours here

local map = vim.keymap.set

map("n", "L",
  function() require("nvchad.tabufline").next() end, { desc = "buffer goto next" })

map("n", "H",
  function() require("nvchad.tabufline").prev() end, { desc = "buffer goto prev" })

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- map({ "n" }, "-", "<cmd>Oil <cr>")
map({ "n" }, "<leader>fp", "<cmd>Telescope projects<cr>")
map({ "n" }, "<leader><leader>", "<cmd>Telescope find_files<cr>")
map({ "n" }, "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "find word under cursor" })
map({ "n" }, "<leader>/", "<cmd>Telescope live_grep<cr>", { desc = "find word" })
map({ "n" }, "<leader>ds", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "LSP diagnostic open float" })

-- Bookmarks
map({ "n" }, "<leader>fB", "<cmd>BookmarksLists<cr>")
map({ "n" }, "]b", "<cmd>BookmarksGotoNextInList<cr>")
map({ "n" }, "[b", "<cmd>BookmarksGotoPrevInList<cr>")

vim.keymap.set('n', '<leader>cP', function()
  vim.cmd('let @+ = expand("%:p")')
  vim.notify('Full path copied to clipboard', vim.log.levels.INFO, { title = 'Path Copied' })
end, { desc = 'copy full current file path' })

vim.keymap.set('n', '<leader>cp', function()
  vim.cmd('let @+ = expand("%")')
  vim.notify('Relative path copied to clipboard', vim.log.levels.INFO, { title = 'Path Copied' })
end, { desc = 'copy relative current file path' })

map({ "n" }, "]h", function() require("gitsigns").nav_hunk('next', { target = "all" }) end,
  { desc = "Next hunk" })
map({ "n" }, "[h", function() require("gitsigns").nav_hunk('prev', { target = "all" }) end,
  { desc = "Prev hunk" })

map({ "n", "t" }, "<a-l>",
  function() require("nvchad.term").toggle { pos = "float", id = "lazygit", cmd = "lazygit", } end,
  { desc = "Toggle floating LazyGit window" })

map({ "n", "t" }, "<a-a>",
  function() require("nvchad.term").toggle { pos = "sp", id = "aider", cmd = "aider", } end,
  { desc = "Aider✨" })

map("n", "[n",
  function() require("treesitter-context").go_to_context(vim.v.count1) end,
  { silent = true, desc = "Go to context" })
