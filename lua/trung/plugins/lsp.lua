return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufEnter',
    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = {
          registries = {
            'github:mason-org/mason-registry',
            'github:Crashdummyy/mason-registry',
          },
        },
      },
      'mason-org/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('trung-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
          map('gri', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
          map('grd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', function() Snacks.picker.lsp_symbols() end, 'Open Document Symbols')
          map('gW', function() Snacks.picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')
          map('grt', function() Snacks.picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')

          vim.cmd 'silent! aunmenu PopUp'
          vim.cmd.amenu '10.10 PopUp.LSP\\ References <cmd>lua Snacks.picker.lsp_references()<CR>'
          vim.cmd.amenu '10.20 PopUp.LSP\\ Implementations <cmd>lua Snacks.picker.lsp_implementations()<CR>'
          vim.cmd.amenu '10.30 PopUp.LSP\\ Definitions <cmd>lua Snacks.picker.lsp_definitions()<CR>'
          vim.cmd.amenu '10.40 PopUp.LSP\\ Type\\ Definition <cmd>lua Snacks.picker.lsp_type_definitions()<CR>'
          vim.cmd.amenu '10.50 PopUp.LSP\\ Declaration <cmd>lua vim.lsp.buf.declaration()<CR>'
          vim.cmd.amenu '10.60 PopUp.LSP\\ Rename <cmd>lua vim.lsp.buf.rename()<CR>'
          vim.cmd.amenu '10.70 PopUp.LSP\\ Code\\ Action <cmd>lua vim.lsp.buf.code_action()<CR>'

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('trung-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('trung-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'trung-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end

          if vim.fn.has 'nvim-0.12' == 1 then
            if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlineCompletion, event.buf) then
              vim.lsp.inline_completion.enable(true, { bufnr = event.buf })
              vim.keymap.set('i', '<c-f>', vim.lsp.inline_completion.get,
                { desc = 'LSP: accept inline completion', buffer = event.buf })
              vim.keymap.set('i', '<c-g>', vim.lsp.inline_completion.select,
                { desc = 'LSP: switch inline completion', buffer = event.buf })
            end
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'single', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local servers = {
        cssls = {},
        pyright = {},
        jsonls = {},
        yamlls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = false,
        automatic_enable = {
          exclude = { 'rust_analyzer', 'ts_ls', 'copilot' },
        },
      }

      vim.lsp.config('cds_lsp', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        settings = {
          cds = {
            validate = true,
          },
        },
      })
      vim.lsp.enable 'cds_lsp'
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        'snacks.nvim',
      },
    },
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        expose_as_code_action = 'all',
      },
    },
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json' },
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '==',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = 'n',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = true,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        yaml = { 'prettierd' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        sql = { 'sleek' },
        bash = { 'beautysh' },
        zsh = { 'beautysh' },
        markdown = { 'prettierd' },
      },
    },
  },
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = { 'rafamadriz/friendly-snippets', 'xzbdmw/colorful-menu.nvim' },
    version = '1.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<c-c>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<c-l>'] = { 'snippet_forward', 'fallback' },
        ['<c-h>'] = { 'snippet_backward', 'fallback' },
        ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
        ['<c-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<c-d>'] = { 'scroll_documentation_down', 'fallback' },
      },
      cmdline = {
        enabled = true,
        keymap = {
          ['<Tab>'] = { 'show', 'accept', 'fallback' },
          ['<S-Tab>'] = { 'show', 'select_prev', 'fallback' },
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
        },
        completion = {
          menu = { auto_show = true },
        },
      },
      completion = {
        documentation = { window = { border = 'single' }, auto_show = true },
        ghost_text = { enabled = true },
        menu = {
          border = 'single',
          draw = {
            columns = { { 'kind_icon' }, { 'label', gap = 1 } },
            components = {
              label = {
                text = function(ctx)
                  return require('colorful-menu').blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require('colorful-menu').blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
      },
      signature = { window = { border = 'single' }, enabled = true },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lsp = { fallbacks = {} },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
