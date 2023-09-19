return {
  { "wellle/targets.vim" },
  -- https://github.com/jamestrew/nvim/issues/83
  -- {
  --   "andymass/vim-matchup",
  --   event = "BufRead",
  --   config = function() vim.g.matchup_matchparen_offscreen = { method = "popup" } end,
  -- },
  { "windwp/nvim-autopairs", config = true },
  { "windwp/nvim-ts-autotag" },
  { "kylechui/nvim-surround", config = true },
  { "echasnovski/mini.move", config = true },
  { "asiryk/auto-hlsearch.nvim", config = true },
  { "norcalli/nvim-colorizer.lua", cmd = { "ColorizerToggle" } },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },

  {
    "ggandor/leap.nvim",
    config = function() require("leap").add_default_mappings() end,
  },

  {
    "Wansmer/treesj",
    keys = { { "<leader>sj", "<cmd>TSJToggle<cr>", desc = "Join Toggle" } },
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
    opts = function(_, opts)
      opts.ignore = "^$"
      opts.pre_hook =
        require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    end,
    event = "VeryLazy",
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-plenary",
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
              diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      require("neotest").setup({
        adapters = {
          require("neotest-go"),
          require("neotest-plenary"),
          require("neotest-rust"),
        },
        diagnostic = { enabled = true, severity = vim.diagnostic.severity.ERROR },
        quickfix = { enabled = false },
      })
    end,
    keys = {
      { "<leader>rt", function() require("neotest").run.run(vim.fn.expand("%")) end },
    },
    enabled = not Work,
  },
}
