local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "solarized-osaka",
        news = {
          lazyvim = true,
          neovim = true,
        },
      },
    },

    -- flutter language
    {
      "akinsho/flutter-tools.nvim",
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim", -- optional for vim.ui.select
      },
      config = function()
        require("flutter-tools").setup({})
      end,
    },

    -- bufferline optimizing tabs
    {
      "akinsho/bufferline.nvim",
      event = "VeryLazy",
      keys = {
        { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
        { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
      },
      opts = {
        options = {
          mode = "tabs",
          show_buffer_close_icons = false,
          shwo_close_icon = false,
        },
      },
    },

    -- tabs optimizing show filename
    {
      "b0o/incline.nvim",
      dependencies = { "craftzdog/solarized-osaka.nvim" },
      event = "BufReadPre",
      priority = 1200,
      config = function()
        local colors = require("solarized-osaka.colors").setup()
        require("incline").setup({
          highlight = {
            groups = {
              InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
              InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
            },
          },
          window = { margin = { vertical = 0, horizontal = 1 } },
          hide = {
            cursorline = true,
          },
          render = function(props)
            local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
            if vim.bo[props.buf].modified then
              filename = "[+] " .. filename
            end

            local icon, color = require("nvim-web-devicons").get_icon_color(filename)
            return { { icon, guifg = color }, { " " }, { filename } }
          end,
        })
      end,
    },

    -- Incremental rename
    {
      "smjonas/inc-rename.nvim",
      cmd = "IncRename",
      config = true,
    },

    -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.coding.copilot" },
    { import = "lazyvim.plugins.extras.util.mini-hipatterns" },

    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
