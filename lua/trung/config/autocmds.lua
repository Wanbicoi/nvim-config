-- set underline for CursorHoldI reference
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    -- Link all reference types to a clean underline style
    vim.api.nvim_set_hl(0, 'LspReferenceText', { underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { underline = true })
    vim.api.nvim_set_hl(0, 'LspReferenceTarget', { underline = true })
  end,
})

vim.api.nvim_set_hl(0, '@function.call.typescript', { link = 'Visual' })
-- Autosave on focus lost
vim.api.nvim_create_autocmd('TextChanged', {
  desc = 'Autosave when focus is lost or buffer is left',
  group = vim.api.nvim_create_augroup('trung-autosave', { clear = true }),
  callback = function()
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    local bufname = vim.api.nvim_buf_get_name(0)
    local ignore_filetypes = { 'oil', 'help', 'diffview', 'gitcommit', 'gitrebase', 'TelescopePrompt', 'snacks_picker_input' }

    if vim.bo.modified and bufname ~= '' and buftype == '' and not vim.tbl_contains(ignore_filetypes, filetype) then
      vim.cmd 'silent! wall'
    end
  end,
})

-- Auto-reload files when they change on disk
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  desc = 'Reload file when focus is gained or buffer is entered',
  group = vim.api.nvim_create_augroup('trung-autoreload', { clear = true }),
  callback = function()
    local buftype = vim.bo.buftype
    if vim.api.nvim_buf_get_name(0) ~= '' and buftype == '' then
      vim.cmd 'checktime'
    end
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('trung-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Add only custom popup actions
-- Always use 100 for PopUp menu
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Setup custom popup menu',
  group = vim.api.nvim_create_augroup('trung-popup-search-menu', { clear = true }),
  callback = function()
    if vim.wo.diff then
      vim.cmd.amenu [[100.210 PopUp.-DiffSep- :]]
      vim.cmd.nmenu [[100.220 PopUp.Diff\ Get <cmd>diffget<CR>]]
      vim.cmd.nmenu [[100.230 PopUp.Diff\ Put <cmd>diffput<CR>]]

      vim.cmd.vmenu [[100.220 PopUp.Diff\ Get <cmd>'<,'>diffget<CR>]]
      vim.cmd.vmenu [[100.230 PopUp.Diff\ Put <cmd>'<,'>diffput<CR>]]
    else
      vim.cmd [[silent! aunmenu PopUp.-DiffSep-]]
      vim.cmd [[silent! aunmenu PopUp.Diff\ Get]]
      vim.cmd [[silent! aunmenu PopUp.Diff\ Put]]
    end

    vim.cmd.nmenu [[100.200 PopUp.-SearchSep- :]]
    vim.cmd.nmenu [[100.205 PopUp.Open\ File\ Under\ Cursor <cmd>lua _G.OpenFileUnderCursor()<CR>]]
    vim.cmd.nmenu [[100.210 PopUp.Copy\ All <cmd>%y+<CR>]]
    vim.cmd.nmenu [[100.212 PopUp.Copy\ File\ Name <cmd>let @+=expand('%:t')<CR>]]
    vim.cmd.nmenu [[100.215 PopUp.Go\ To\ Context <cmd>lua require("treesitter-context").go_to_context(vim.v.count1)<CR>]]
    vim.cmd.nmenu [[100.220 PopUp.Grep\ Word\ (Project\ Root) <cmd>lua require('trung.utils.snacks_search').grep_cword_project()<CR>]]
    vim.cmd.nmenu [[100.230 PopUp.Grep\ Word\ (CWD) <cmd>lua require('trung.utils.snacks_search').grep_cword_pwd()<CR>]]
    vim.cmd.vmenu [[100.240 PopUp.Grep\ Selection\ (Project\ Root) :<C-U>lua require('trung.utils.snacks_search').grep_visual_project()<CR>]]
    vim.cmd.vmenu [[100.250 PopUp.Grep\ Selection\ (CWD) :<C-U>lua require('trung.utils.snacks_search').grep_visual_pwd()<CR>]]
  end,
})

-- Auto load script
vim.api.nvim_create_autocmd('DirChanged', {
  callback = function()
    local file = vim.fn.getcwd() .. '/.nvim.lua'
    if vim.fn.filereadable(file) == 1 and vim.secure.trust { action = 'allow', path = file } then
      dofile(file)
      print('Loaded local config: ' .. file)
    end
  end,
})

-- lsp rename file
vim.api.nvim_create_autocmd('User', {
  pattern = 'OilActionsPost',
  callback = function(event)
    if event.data.actions[1].type == 'move' then
      Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
    end
  end,
})

-- Show lsp progress
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= 'table' then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ('[%3d%%] %s%s'):format(
            value.kind == 'end' and 100 or value.percentage or 100,
            value.title or '',
            value.message and (' **%s**'):format(value.message) or ''
          ),
          done = value.kind == 'end',
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    vim.notify(table.concat(msg, '\n'), 'info', {
      id = 'lsp_progress',
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

