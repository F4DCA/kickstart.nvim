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
        c = function(...)
        local c_base = {
          "cd $dir &&",
          "clang $fileName -o",
          "/tmp/$fileNameWithoutExt",
        }
        local c_exec = {
          "&& /tmp/$fileNameWithoutExt &&",
          "rm /tmp/$fileNameWithoutExt",
        }
        vim.ui.input({ prompt = "Add more args:" }, function(input)
        c_base[4] = input
        require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
        end)
        end,
        tex = "pdflatex $fileName"
      },
    })

    -- Keybindings for code_runner
    vim.keymap.set("n", "<leader>R", ":RunCode<CR>", { noremap = true, silent = false })
    vim.keymap.set("n", "<leader>Rf", ":RunFile<CR>", { noremap = true, silent = false })
    vim.keymap.set("n", "<leader>Rft", ":RunFile tab<CR>", { noremap = true, silent = false })
    vim.keymap.set("n", "<leader>Rp", ":RunProject<CR>", { noremap = true, silent = false })
    vim.keymap.set("n", "<leader>Rc", ":RunClose<CR>", { noremap = true, silent = false })
    end,
  },

  -- Add material.nvim
  --{
  --  "marko-cerovac/material.nvim",
  --  dependencies = { "nvim-lualine/lualine.nvim", "nvim-tree/nvim-web-devicons" },
  --  config = function()
  --  -- Set up material.nvim
  --  require("material").setup({
  --    lualine_style = "default", -- Choose 'default' or 'stealth'
  --  })
  --  vim.g.material_style = "deep ocean"
  --  vim.cmd("colorscheme material") -- Activate the material colorscheme
  --},

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
        "PmenuSel",   -- Selected item in popup menu
        "PmenuSbar",  -- Popup menu scrollbar
        "PmenuThumb" -- Popup menu scrollbar thumb
      },
      -- exclude_groups = {}, -- table: groups you don't want to clear
    })
    require('transparent').clear_prefix('NeoTree')
    require('transparent').clear_prefix('lualine')
    require('transparent').clear_prefix('BufferLine')
    end,
  },
}
