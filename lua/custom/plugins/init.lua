---@diagnostic disable: missing-fields
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {},
  },
  -- Detect tabstop and shiftwidth automatically
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {}, -- this is equalent to setup({}) function
  },
  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',

        opts = {
          text = {
            spinner = 'dots_snake', -- animation shown when tasks are ongoing
          },
          window = {
            blend = 0, -- &winblend for the window
          },
        },
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/neodev.nvim', opts = {} },
    },
    event = 'VeryLazy',
    config = function()
      -- [[ Configure LSP ]]
      --  This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>.', vim.lsp.buf.code_action, 'Code action')

        nmap('gD', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype [D]efinition')
        nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [d]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [r]eferences')
        nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [i]mplementation')
        nmap('gi', require('telescope.builtin').lsp_incoming_calls, '[G]oto [I]ncoming calls')
        nmap('go', require('telescope.builtin').lsp_outgoing_calls, '[G]oto [o]utgoing calls')

        -- See `:help K` for why this keymap
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('gh', vim.lsp.buf.signature_help, 'Signature Documentation')

        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')
      end

      -- typescript specification

      local servers = {
        tailwindcss = {},
        cssls = {},
        jsonls = {},
        html = { filetypes = { 'html', 'twig', 'hbs' } },
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
          }

          require('typescript-tools').setup {
            server = { -- pass options to lspconfig's setup method
              on_attach = on_attach,
              capabilities = capabilities,
            },
          }
        end,
      }
    end,
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'onsails/lspkind.nvim',

      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',

      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      -- 'tzachar/cmp-tabnine',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      -- require('lazy').setup {
      --   {
      --     'tzachar/cmp-tabnine',
      --     build = './install.sh',
      --     dependencies = 'hrsh7th/nvim-cmp',
      --   },
      -- }
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      require('luasnip.loaders.from_vscode').lazy_load()

      luasnip.config.setup {}
      cmp.setup {
        window = {
          completion = cmp.config.window.bordered { scrollbar = false },
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = require('lspkind').cmp_format {
              mode = 'symbol_text',
              maxwidth = 50,
              symbol_map = { TabNine = '' },
            }(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = ' ' .. (strings[1] or '') .. ' '
            kind.menu = '    [' .. (strings[2] or '') .. ']'

            -- Customization for Pmenu
            vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#282C34', fg = 'NONE' })
            vim.api.nvim_set_hl(0, 'Pmenu', { fg = '#C5CDD9', bg = '#22252A' })

            vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { fg = '#7E8294', bg = 'NONE', strikethrough = true })
            vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = '#82AAFF', bg = 'NONE', bold = true })
            vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { fg = '#82AAFF', bg = 'NONE', bold = true })
            vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = '#B5585F', bg = 'NONE', italic = true })

            vim.api.nvim_set_hl(0, 'CmpItemKindField', { fg = '#ffffff', bg = '#B5585F' })
            vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { fg = '#ffffff', bg = '#B5585F' })
            vim.api.nvim_set_hl(0, 'CmpItemKindEvent', { fg = '#ffffff', bg = '#B5585F' })

            vim.api.nvim_set_hl(0, 'CmpItemKindText', { fg = '#ffffff', bg = '#00dd00' })
            vim.api.nvim_set_hl(0, 'CmpItemKindEnum', { fg = '#ffffff', bg = '#00dd00' })
            vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { fg = '#ffffff', bg = '#00dd00' })

            vim.api.nvim_set_hl(0, 'CmpItemKindConstant', { fg = '#ffffff', bg = '#D4BB6C' })
            vim.api.nvim_set_hl(0, 'CmpItemKindConstructor', { fg = '#ffffff', bg = '#D4BB6C' })
            vim.api.nvim_set_hl(0, 'CmpItemKindReference', { fg = '#ffffff', bg = '#D4BB6C' })

            vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { fg = '#ffffff', bg = '#A377BF' })
            vim.api.nvim_set_hl(0, 'CmpItemKindStruct', { fg = '#ffffff', bg = '#A377BF' })
            vim.api.nvim_set_hl(0, 'CmpItemKindClass', { fg = '#ffffff', bg = '#A377BF' })
            vim.api.nvim_set_hl(0, 'CmpItemKindModule', { fg = '#ffffff', bg = '#A377BF' })
            vim.api.nvim_set_hl(0, 'CmpItemKindOperator', { fg = '#ffffff', bg = '#A377BF' })

            vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { fg = '#ffffff', bg = '#7E8294' })
            vim.api.nvim_set_hl(0, 'CmpItemKindFile', { fg = '#ffffff', bg = '#7E8294' })

            vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { fg = '#ffffff', bg = '#D4A959' })
            vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { fg = '#ffffff', bg = '#D4A959' })
            vim.api.nvim_set_hl(0, 'CmpItemKindFolder', { fg = '#ffffff', bg = '#D4A959' })

            vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { fg = '#ffffff', bg = '#6C8ED4' })
            vim.api.nvim_set_hl(0, 'CmpItemKindValue', { fg = '#ffffff', bg = '#6C8ED4' })
            vim.api.nvim_set_hl(0, 'CmpItemKindEnumMember', { fg = '#ffffff', bg = '#6C8ED4' })

            vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { fg = '#ffffff', bg = '#58B5A8' })
            vim.api.nvim_set_hl(0, 'CmpItemKindColor', { fg = '#ffffff', bg = '#58B5A8' })
            vim.api.nvim_set_hl(0, 'CmpItemKindTypeParameter', { fg = '#ffffff', bg = '#58B5A8' })

            vim.api.nvim_set_hl(0, 'CmpItemKindTabNine', { fg = '#ffff00', bg = '#37244C' })
            return kind
          end,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'buffer' },
          { name = 'orgmode' },
          -- { name = 'cmp_tabnine' },
          -- { name = 'codeium' },
        },
      }
    end,
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    event = 'BufEnter',
    config = function()
      require('null-ls').setup {
        sources = {
          require('null-ls').builtins.formatting.stylua, -- shell script formatting
          require('null-ls').builtins.formatting.prettierd, -- markdown formatting
          require('null-ls').builtins.formatting.clang_format, -- markdown formatting
          -- require('null-ls').builtins.diagnostics.eslint,
          -- require('null-ls').builtins.code_actions.eslint,
        },
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePost', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format()
              end,
            })
          end
        end,
      }
    end,
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'BufEnter',
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = '<author>',
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', ']h', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Next Hunk' })
        vim.keymap.set('n', '[h', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Prev Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = { globalstatus = true },
        sections = {
          -- lualine_b = { 'branch', 'diagnostics' },
          lualine_c = { { 'filename', path = 3 } },
        },
      }
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      scope = { enabled = false },
    },
    dependencies = {
      {
        'echasnovski/mini.nvim',
        version = '*',
        config = function()
          require('mini.indentscope').setup { symbol = '│' }
        end,
      },
    },
    event = 'BufEnter',
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- 'nvim-telescope/telescope-file-browser.nvim',
      {
        'ahmedkhalf/project.nvim',
        config = function()
          require('project_nvim').setup {
            detection_methods = { 'pattern' },
          }
        end,
      },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategy = 'bottom_pane',
        },
        -- extensions = {
        --   file_browser = {
        --     theme = 'ivy',
        --   },
        -- },
        pickers = {
          lsp_references = {
            theme = 'ivy',
          },
          find_files = {
            theme = 'ivy',
            hidden = true,
          },
          live_grep = {
            theme = 'ivy',
          },
          oldfiles = {
            theme = 'ivy',
          },
          buffers = {
            ignore_current_buffer = true,
          },
        },
      }

      -- require('telescope').load_extension 'file_browser'
      require('telescope').load_extension 'projects'

      vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', require('telescope.builtin').find_files, { desc = '[/] Find files' })

      vim.keymap.set('n', '<leader>sp', '<cmd>Telescope projects<cr>', { desc = '[S]earch recent [P]rojects' })
      vim.keymap.set('n', '<leader>sr', '<cmd>Telescope resume<cr>', { desc = '[S]earch [R]esume' })

      -- vim.keymap.set(
      --   'n',
      --   '<leader>sf',
      --   "<cmd>lua require 'telescope'.extensions.file_browser.file_browser({ depth = false, display_stat = false, cwd = vim.fn.expand('%:p:h') })<CR>",
      --   { desc = '[S]earch [F]ile browser' }
      -- )
      vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

      local signs = { Error = '', Warn = '', Hint = '💡', Info = '' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'joosepalviste/nvim-ts-context-commentstring',
      'windwp/nvim-ts-autotag',
      -- 'nvim-treesitter/playground',
    },
    build = ':TSUpdate',
    lazy = false,
    config = function()
      require('nvim-treesitter.configs').setup {
        -- playground = {
        --   enable = true,
        --   disable = {},
        --   updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
        --   persist_queries = false, -- Whether the query persists across vim sessions
        --   keybindings = {
        --     toggle_query_editor = 'o',
        --     toggle_hl_groups = 'i',
        --     toggle_injected_languages = 't',
        --     toggle_anonymous_nodes = 'a',
        --     toggle_language_display = 'I',
        --     focus_language = 'f',
        --     unfocus_language = 'F',
        --     update = 'R',
        --     goto_node = '<cr>',
        --     show_help = '?',
        --   },
        -- },
        autotag = {
          enable = true,
          enable_close_on_slash = false,
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        -- textobjects = {
        --   lookahead = false,
        --   select = {
        --     enable = true,
        --     keymaps = {
        --       ['af'] = { query = '@function.outer', desc = 'inner function' },
        --       ['if'] = { query = '@function.inner', desc = ' outer function' },
        --       ['ac'] = { query = '@call.outer', desc = 'outer call' },
        --       ['ic'] = { query = '@call.inner', desc = 'inner call' },
        --       ['io'] = { query = '@block.inner', desc = 'inner block' },
        --       ['ao'] = { query = '@block.outer', desc = 'outer block' },
        --       ['ia'] = { query = '@assignment.inner', desc = 'inner assignment' },
        --       ['aa'] = { query = '@assignment.outer', desc = 'outer assignment' },
        --     },
        --   },
        -- },
        ensure_installed = {
          'comment',
          'vim',
          'lua',
          'html',
          'css',
          'javascript',
          'typescript',
          'tsx',
          'c',
          'markdown',
          'markdown_inline',
        },
        indent = {
          enable = true,
        },
      }
    end,
  },

  {
    'numToStr/Comment.nvim',
    event = 'BufEnter',
    dependencies = 'joosepalviste/nvim-ts-context-commentstring',
    config = function()
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    },
    event = 'VeryLazy',
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = 'BufEnter',
    opts = { '*' },
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
      },
    },
    event = 'VeryLazy',
  },
  {
    'folke/trouble.nvim',
    event = 'BufEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  { 'wakatime/vim-wakatime', event = 'VeryLazy' },
  {
    'kylechui/nvim-surround',
    version = '*', -- use for stability; omit to use `main` branch for the latest features
    event = 'BufEnter',
    opts = {},
  },
  {
    'kdheepak/lazygit.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>gl',
        '<cmd>LazyGit<cr>',
        desc = 'LazyGit',
      },
    },
    -- optional for floating window border decoration
    dependencies = 'nvim-lua/plenary.nvim',
  },
  {
    'tamton-aquib/duck.nvim',
    keys = {
      {
        '<leader>dd',
        function()
          require('duck').hatch()
        end,
        desc = 'Duck Duck!',
      },
      {
        '<leader>ds',
        function()
          require('duck').hatch('🐏', 10)
        end,
        desc = 'Duck Sheep!',
      },
      {
        '<leader>dc',
        function()
          require('duck').cook()
        end,
        desc = 'Duck Cook',
      },
    },
  },
  {
    'nvim-pack/nvim-spectre',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = {
      {
        '<leader>S',
        function()
          require('spectre').toggle()
          vim.cmd 'hi SpectreSearch guifg=white'
          vim.cmd 'hi SpectreReplace guifg=white guibg=green'
        end,
        desc = 'Spectre',
      },
    },
  },
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    opts = {
      input = {
        min_width = { 30, 0.2 }, -- means "the greater of 20 columns or 20% of total"
        win_options = {
          -- Window transparency (0-100)
          winblend = 70,
        },
      },
    },
  },
  {
    'rhysd/conflict-marker.vim',
    event = 'VeryLazy',
  },
  {
    'rmagatti/goto-preview',
    event = 'VeryLazy',
    opts = {
      default_mappings = true,
    },
  },
  {
    'moll/vim-bbye',
    event = 'BufEnter',
  },
  {
    'stevearc/oil.nvim',
    keys = {
      {
        '-',
        function()
          require('oil').toggle_float(vim.fn.expand '%:h:p')
        end,
        desc = '[O]il float current file directory',
      },
    },
    opts = {
      float = {
        border = 'single',
        padding = 4,
        max_width = 75,
      },
    },
    event = 'VeryLazy',
  },

  -- [[Colorscheme]]
  {
    'olimorris/onedarkpro.nvim',
    priority = 1000,
    config = function()
      require('onedarkpro').setup {
        styles = {
          types = 'NONE',
          methods = 'NONE',
          numbers = 'NONE',
          strings = 'NONE',
          comments = 'italic',
          -- keywords = 'bold,italic',
          constants = 'italic',
          -- functions = 'italic',
          operators = 'NONE',
          variables = 'italic',
          parameters = 'italic',
          -- conditionals = 'italic',
          virtual_text = 'bold',
        },
        colors = {
          cursorline = '#eeeeee', -- This is optional. The default cursorline color is based on the background
        },
        options = {
          cursorline = true,
        },
        -- options = {
        --   transparency = true,
        -- },
      }
      -- vim.cmd.colorscheme 'onelight'

      -- vim.cmd 'highlight Cursor guifg=#7f7f7f'

      -- vim.cmd 'highlight IndentBlanklineChar guifg=#006070 gui=nocombine'
      -- vim.cmd 'highlight NormalFloat guibg=NONE'
      -- vim.cmd 'highlight FloatBorder guibg=NONE'
    end,
  },
  { 'arcticicestudio/nord-vim', },
  { 'sainnhe/gruvbox-material', },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          separator_style = 'slant',
          diagnostics = 'nvim_lsp',
          indicator = {
            style = 'icon',
          },
          diagnostics_indicator = function(count, level)
            local icon = level:match 'error' and ' ' or ' '
            return icon .. count
          end,
        },
      }

      vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<cr>')
      vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<cr>')
    end,
  },
  {
    'mbbill/undotree',
    event = 'VeryLazy',
  },
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons', -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },

  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        highlights = {
          Normal = {
            guibg = NONE,
          },
        },
      }
      vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = '[T]oggle [f]loat term' })
      vim.keymap.set('n', '<leader>th', ':ToggleTerm direction=horizontal<cr>', { desc = '[T]oggle [h]orizontal term' })
      vim.keymap.set('n', '<leader>tv', ':ToggleTerm direction=vertical<cr>', { desc = '[T]oggle [v]ertical term' })
      vim.keymap.set('n', '<leader>ts', '<cmd>TermSelect <cr>', { desc = '[T]erm [s]elect' })
      vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTermToggleAll <cr>', { desc = '[T]oggle term [t]oggle all' })

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<C-\\>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end

      vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'
    end,
  },
  {
    'rest-nvim/rest.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('rest-nvim').setup {
        -- result_split_horizontal = false,
        result_split_in_place = true,
        result = {
          show_url = false,
          show_curl_command = false,
          show_http_info = true,
          show_headers = false,
        },
      }
      vim.keymap.set('n', '<leader>rr', '<Plug>RestNvim', { desc = '[R]est [R]un' })
      vim.keymap.set('n', '<leader>rl', '<Plug>RestNvimLast', { desc = '[R]est [L]ast' })
      vim.keymap.set('n', '<leader>rp', '<Plug>RestNvimPreview', { desc = '[R]est [P]review' })
    end,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('refactoring').setup()

      -- load refactoring Telescope extension
      require('telescope').load_extension 'refactoring'
      vim.keymap.set({ 'n', 'x' }, '<leader>R', function()
        require('telescope').extensions.refactoring.refactors()
      end)
    end,
  },
  {
    'simrat39/symbols-outline.nvim',
    opts = {},
    keys = {
      {
        '<leader>so',
        '<cmd>SymbolsOutline<cr>',
        desc = '[S]ymbols [O]utline',
      },
    },
  },
  --   {
  --     'nvim-orgmode/orgmode',
  --     event = "VeryLazy",
  --     config = function()
  -- require('orgmode').setup_ts_grammar()
  --     require('orgmode').setup({
  --       org_agenda_files = '~/orgfiles/**/*',
  --       org_default_notes_file = '~/orgfiles/refile.org',
  --     })
  --     end,
  --   },
  -- {
  --   'max397574/better-escape.nvim',
  --   config = function()
  --     require('better_escape').setup {
  --       mapping = { 'jj' },
  --     }
  --   end,
  -- },
  -- {
  --   'Bekaboo/dropbar.nvim',
  --   event = 'VeryLazy',
  --   config = function()
  --     require('dropbar').setup()
  --     vim.keymap.set('n', '<leader>q', "<cmd>lua require('dropbar.api').pick()<cr>", { desc = 'Dropbar' })
  --   end,
  -- },

  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',
}
