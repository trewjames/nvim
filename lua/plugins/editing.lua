return {
  { "wellle/targets.vim" },
  { "andymass/vim-matchup" },
  { "Vimjas/vim-python-pep8-indent" },
  { "gpanders/editorconfig.nvim", enabled = not Work },
  { "windwp/nvim-autopairs", config = true },
  { "kylechui/nvim-surround", config = true },
  { "booperlv/nvim-gomove", config = function() require("gomove").setup() end },
  { "norcalli/nvim-colorizer.lua", config = function() require("colorizer").setup() end },
  { "asiryk/auto-hlsearch.nvim", config = true },

  {
    "ggandor/leap.nvim",
    config = function() require("leap").add_default_mappings() end,
  },

  {
    "utilyre/barbecue.nvim",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = true,
  },

  {
    "Wansmer/treesj",
    keys = {
      { "<leader>sj", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  {
    "smjonas/live-command.nvim",
    config = function()
      require("live-command").setup({
        commands = {
          Norm = { cmd = "norm" },
          S = { cmd = "g" },
          Reg = {
            cmd = "norm",
            args = function(opts)
              return (opts.count == -1 and "" or opts.count) .. "@" .. opts.args
            end,
            range = "",
          },
        },
      })
    end,
  },

  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      char = "▏",
      filetype_exclude = { "help", "terminal", "dashboard", "man" },
      buftype_exclude = { "terminal", "nofile", "quickfix", "prompt" },
      show_trailing_blankline_indent = false,
      show_current_context = true,
      show_current_context_start = false,
    },
  },
}