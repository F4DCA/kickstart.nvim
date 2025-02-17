return {

  -- Add code_runner.nvim
  {
    "CRAG666/code_runner.nvim",
    config = function()
    require("code_runner").setup({
      filetype = {
        java = {
          "cd $dir &&",
          "javac $fileName &&",
          "java $fileNameWithoutExt"
        },
        python = "python3 -u",
        typescript = "deno run",
        rust = {
          "cd $dir &&",
          "rustc $fileName &&",
          "$dir/$fileNameWithoutExt"
        },
        c = {
          "cd $dir &&",
          "gcc $fileName -o /tmp/$fileNameWithoutExt &&",
          "/tmp/$fileNameWithoutExt",
          "; rm -f /tmp/$fileNameWithoutExt"
        },
        cpp = {
          "cd $dir &&",
          "g++ $fileName -o /tmp/$fileNameWithoutExt &&",
          "/tmp/$fileNameWithoutExt",
          "; rm -f /tmp/$fileNameWithoutExt"
        },
        tex = "pdflatex $fileName"
      },
    })
    vim.keymap.set("n", "<leader>R", ":RunCode<CR>", { desc = '[R]un Code', noremap = true, silent = false })
    vim.keymap.set("n", "<leader>Rf", ":RunFile<CR>", { desc = '[R]un [f]ile', noremap = true, silent = false })
    vim.keymap.set("n", "<leader>Rft", ":RunFile tab<CR>", { desc = '[R]un [f]ile [t]ab', noremap = true, silent = false })
    vim.keymap.set("n", "<leader>Rp", ":RunProject<CR>", { desc = '[R]un [p]roject', noremap = true, silent = false })
    vim.keymap.set("n", "<leader>Rc", ":RunClose<CR>", { desc = '[R]un [c]lose', noremap = true, silent = false })
    vim.keymap.set("n", "<leader>Ra", function()
    local filetype = vim.bo.filetype
    if filetype == "c" or filetype == "cpp" then
      local base_cmd = {
        "cd $dir &&",
        (filetype == "c" and "gcc" or "g++") .. " $fileName -o /tmp/$fileNameWithoutExt",
      }
      local exec_cmd = {
        "&& /tmp/$fileNameWithoutExt",
        "; rm -f /tmp/$fileNameWithoutExt",
      }
      vim.ui.input({ prompt = "Add more args:" }, function(input)
      if input and input ~= "" then
        table.insert(base_cmd, input)
        end
        require("code_runner.commands").run_from_fn(vim.list_extend(base_cmd, exec_cmd))
        end)
      else
        print("Current filetype does not support additional arguments.")
        end
        end, { desc = "[R]un with [a]rgs", noremap = true, silent = false })
    end,
  },

  -- Add bufferline.nvim
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- set to "tabs" to only show tabpages instead
          numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
          close_command = "bdelete! %d", -- can be a string | function, | false see "Mouse actions"
          right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
          left_mouse_command = "buffer %d", -- can be a string | function, | false see "Mouse actions"
          middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
          indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon', -- | 'underline' | 'none',
          },
          buffer_close_icon = '󰅖',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          offsets = {
            {
              filetype = "NeoTree",
              text = "File Explorer",
              text_align = "left",
              separator = true
            }
          },
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          separator_style = "thin",
          always_show_bufferline = true,
          sort_by = 'id'
        }
      })

      -- Add some keymaps for bufferline
      vim.keymap.set('n', '<leader>bp', ':BufferLinePick<CR>', { noremap = true, silent = true, desc = 'Pick buffer' })
      vim.keymap.set('n', '<leader>bc', ':BufferLinePickClose<CR>', { noremap = true, silent = true, desc = 'Pick buffer to close' })
      vim.keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true, desc = 'Next buffer' })
      vim.keymap.set('n', '<S-h>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true, desc = 'Previous buffer' })
    end,
  },

  -- Add nvim-web-devicons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
    require("nvim-web-devicons").setup {
      -- Your custom setup here
      override = {},
      default = true,
    }
    end
  },

  -- Add lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
    require("lualine").setup {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {},
        always_divide_middle = true,
      },
    }
    end
  },

  -- Add transparent.nvim
  {
    "xiyaowong/transparent.nvim",
    lazy = false, -- We want this to load right away to prevent flash of background
    config = function()
    require("transparent").setup({
      -- Optional configuration
      -- You can specify groups to exclude or include for transparency
      extra_groups = {
        "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
        "NvimTreeNormal", -- NvimTree
        "FloatBorder", -- Border of floating windows
        "Pmenu",      -- Popup menu
        -- "PmenuSel",   -- Selected item in popup menu
        "PmenuSbar",  -- Popup menu scrollbar
        "PmenuThumb" -- Popup menu scrollbar thumb
      },
      -- exclude_groups = {}, -- table: groups you don't want to clear
    })
    require('transparent').clear_prefix('NeoTree')
    -- require('transparent').clear_prefix('lualine')
    require('transparent').clear_prefix('BufferLine')
    end,
  },

  -- Add material.nvim
  {
    "marko-cerovac/material.nvim",
    priority = 1000,
    config = function()
    vim.g.material_style = "deep ocean"

    require('material').setup({
      contrast = {
        terminal = false,
        sidebars = false,
        floating_windows = false,
        cursor_line = false,
        non_current_windows = false,
        filetypes = {},
      },
      styles = {
        comments = { italic = true },
        strings = { --[[ no style ]] },
        keywords = { --[[ no style ]] },
        functions = { --[[ no style ]] },
        variables = { --[[ no style ]] },
        operators = { --[[ no style ]] },
        types = { --[[ no style ]] },
      },
      plugins = {
        "gitsigns",
        "mini",
        "neo-tree",
        "nvim-cmp",
        "nvim-web-devicons",
        "telescope",
        "which-key",
      },
      disable = {
        colored_cursor = false,
        borders = false,
        background = false,
        term_colors = false,
        eob_lines = false
      },
      high_visibility = {
        lighter = false,
        darker = false
      },
      lualine_style = "default",
      async_loading = true,
      custom_highlights = {},
      custom_colors = {},
    })

    vim.cmd 'colorscheme material'
    end
  },

  -- Install LuaSnip with friendly-snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets", -- friendly-snippets as dependency
    },
    config = function()
      -- Set LuaSnip configuration options
      require("luasnip").config.set_config({
        enable_autosnippets = true,          -- Automatically trigger snippets where applicable
        store_selection_keys = "<Tab>",      -- Use Tab to store your visual selection for a snippet
      })

      -- Load snippets from friendly-snippets (VSCode snippet format)
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Optionally, if you have personal snippets stored in a custom directory:
      -- require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })

      -- Key mappings for snippet expansion and navigation
      -- These mappings use Vimscript inside a vim.cmd block for brevity.
      vim.cmd([[
        " Use Tab to either expand a snippet or jump to the next snippet placeholder
        imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
        smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

        " Use Shift-Tab to jump backwards through snippet placeholders
        imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
        smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
      ]])
    end,
  },

  -- Install VimTeX
  {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "zathura"
    end
  },
}
