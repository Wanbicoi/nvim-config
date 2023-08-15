-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- TODO move this file to ../lua/plugins.lua
return {
  -- Detect tabstop and shiftwidth automatically
  -- 'tpope/vim-sleuth',
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
      'jose-elias-alvarez/typescript.nvim',
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
      { 'folke/neodev.nvim',       opts = {} },
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
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help,
          { border = 'rounded' })
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
        prismals = {},
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

          require('typescript').setup {
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
      'tzachar/cmp-tabnine',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
    },
    config = function()
      require('lazy').setup {
        {
          'tzachar/cmp-tabnine',
          build = 'powershell ./install.ps1',
          dependencies = 'hrsh7th/nvim-cmp',
        },
      }
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
            } (entry, vim_item)
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
          { name = 'cmp_tabnine' },
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
          require('null-ls').builtins.formatting.stylua,    -- shell script formatting
          require('null-ls').builtins.formatting.prettierd, -- markdown formatting
          -- require('null-ls').builtins.diagnostics.eslint,
          -- require('null-ls').builtins.code_actions.eslint,
        },
      }
    end,
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'BufEnter',
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = '<author>',
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', ']h', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Next Hunk' })
        vim.keymap.set('n', '[h', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Prev Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  {
    'nvim-lualine/lualine.nvim',
    config = function()
      local cs_dracula = require 'lualine.themes.dracula'
      -- cs_dracula.normal.c.bg = NONE
      -- cs_dracula.insert.c.bg = NONE
      -- cs_dracula.visual.c.bg = NONE
      -- cs_dracula.replace.c.bg = NONE
      -- cs_dracula.inactive.c.bg = NONE
      require('lualine').setup {
        options = { theme = cs_dracula, globalstatus = true },
        sections = {
          lualine_c = { { 'filename', path = 1 } },
        },
      }
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    event = 'BufEnter',
    opts = {
      show_current_context = true,
    },
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
        '<leader>O',
        function()
          require('oil').toggle_float(vim.fn.expand '%:h:p')
        end,
        desc = '[O]il float current file directory',
      },
      {
        '<leader>o',
        function()
          require('oil').open(vim.fn.expand '%:h:p')
        end,
        desc = '[O]il current file directory',
      },
    },
    opts = {},
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
        -- options = {
        --   transparency = true,
        -- },
      }
      vim.cmd.colorscheme 'onedark'

      -- vim.cmd 'highlight IndentBlanklineChar guifg=#006070 gui=nocombine'
      -- vim.cmd 'highlight NormalFloat guibg=NONE'
      -- vim.cmd 'highlight FloatBorder guibg=NONE'
    end,
  },

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

  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',
}
