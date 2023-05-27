local M = {
  "nvim-telescope/telescope.nvim",
  dir = "/home/jt/projects/telescope.nvim",
  dev = true,
  dependencies = {
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      dir = "/home/jt/projects/telescope-file-browser.nvim/master",
      -- dir = "/home/jt/projects/telescope-file-browser.nvim/owner-group-stats",
      name = "telescope-file-browser.nvim",
      dev = true,
    },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    { "tsakirist/telescope-lazy.nvim" },
    { "debugloop/telescope-undo.nvim" },
    { "stevearc/dressing.nvim" },
    {
      "AckslD/nvim-neoclip.lua",
      config = true,
      dependencies = {
        { "kkharji/sqlite.lua", enabled = not Work },
      },
    },
    {
      "ibhagwan/fzf-lua",
      cmd = "FzfLua",
    },
  },
  cmd = "Telescope",
}

M.keys = function()
  local jtelescope = require("plugins.telescope.pickers")
  local tele_ext = require("telescope").extensions
  return {
    { "<C-p>", jtelescope.project_files },
    { "<leader><C-p>", function() jtelescope.project_files({}, true) end },
    { "<C-e>", ":Telescope file_browser<CR>", silent = true },
    {
      "<leader><C-e>",
      ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
      silent = true,
    },
    { "<leader>fw", ":Telescope live_grep<CR>", silent = true },
    { "<leader><leader>fw", tele_ext.live_grep_args.live_grep_args },
    { "<leader>gf", jtelescope.live_grep_file },
    { "<leader>gc", ":Telescope git_commits<CR>", silent = true },
    { "<leader>fb", ":Telescope buffers<CR>", silent = true },
    { "<leader>fh", ":Telescope help_tags<CR>", silent = true },
    { "<leader>gw", ":Telescope grep_string<CR>", silent = true },
    { "<leader>rc", jtelescope.search_dotfiles },
    { "<leader>fg", jtelescope.git_worktrees },
    { "<leader>ct", jtelescope.create_git_worktree },
    { "<leader>fy", jtelescope.neoclip },
    { "<leader>ff", jtelescope.curbuf },
    { "<leader>fc", ":Telescope commands<CR>", silent = true },
    { "<leader>gh", jtelescope.git_hunks },
    { "<leader>vrc", jtelescope.search_dotfiles },
    { "<leader><leader>u", ":Telescope undo<CR>", silent = true },
  }
end

M.config = function()
  local sorters = require("telescope.sorters")
  local actions = require("telescope.actions")
  local action_layout = require("telescope.actions.layout")
  local builtin = require("telescope.builtin")

  local tele_utils = require("plugins.telescope.utils")
  local fb_actions = require("telescope._extensions.file_browser.actions")

  require("telescope").setup({
    defaults = {
      prompt_prefix = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "descending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "bottom",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = function(_, cols, _)
          if cols > 200 then
            return 170
          else
            return math.floor(cols * 0.87)
          end
        end,
        height = 0.80,
        preview_cutoff = 120,
      },
      file_sorter = sorters.get_fuzzy_file,
      file_ignore_patterns = { "node_modules", "%.lock", "package-lock.json" },
      generic_sorter = sorters.get_generic_fuzzy_sorter,
      -- path_display = { "smart" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      use_less = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      -- cycle_layout_list = tele_utils.cycle_layouts,
      mappings = {
        i = {
          ["<C-p>"] = actions.move_selection_better,
          ["<C-n>"] = actions.move_selection_worse,
          ["<C-s>"] = actions.select_horizontal,
          ["<Esc>"] = actions.close,
          ["<C-c>"] = false,
          ["<M-p>"] = action_layout.toggle_preview,
          ["<M-l>"] = action_layout.cycle_layout_next,
          ["<C-t>"] = actions.toggle_all,
        },
        n = {
          ["<C-p>"] = actions.move_selection_better,
          ["<C-n>"] = actions.move_selection_worse,
          ["<M-p>"] = action_layout.toggle_preview,
        },
      },
    },
    pickers = {
      find_files = {
        find_command = { "rg", "--files", "--color", "never", "--no-require-git" },
      },
    },
    extensions = {
      git_worktree = {
        path_display = { "shorten" },
        layout_config = {
          width = 70,
          height = 20,
        },
        ordinal_key = "path",
        items = {
          { "path", 57 },
          { "sha", 7 },
        },
      },
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      },
      media_files = {
        filetypes = { "png", "webp", "jpg", "jpeg" },
        find_cmd = "rg", -- find command (defaults to `fd`)
      },
      frecency = {
        ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
      },
      file_browser = {
        theme = "ivy",
        hijack_netrw = false,
        hidden = { file_browser = true, folder_browser = false },
        grouped = true,
        hide_parent_dir = true,
        quiet = true,
        respect_gitignore = false,
        git_status = true,
        mappings = {
          i = {
            ["<C-b>"] = fb_actions.goto_parent_dir,
            ["<A-n>"] = fb_actions.select_all,
            ["<A-f>"] = tele_utils.open_using(builtin.find_files),
            ["<A-g>"] = tele_utils.open_using(builtin.live_grep),
            ["<C-s>"] = fb_actions.sort_by_date,
            ["<C-e>"] = tele_utils.current_bufr_dir,
            ["<C-w>"] = { "<c-s-w>", type = "command" },
          },
          n = {
            ["<A-f>"] = tele_utils.open_using(builtin.find_files),
            ["<A-g>"] = tele_utils.open_using(builtin.live_grep),
            ["<C-b>"] = fb_actions.goto_parent_dir,
            ["s"] = fb_actions.sort_by_date,
          },
        },
      },
      live_grep_args = {
        auto_quoting = false,
        mappings = {
          i = {
            ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
            ["<C-t>"] = require("telescope-live-grep-args.actions").quote_prompt({
              postfix = " -t",
            }),
          },
          n = {
            ["k"] = require("telescope-live-grep-args.actions").quote_prompt(),
            ["t"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " -t" }),
          },
        },
      },
    },
  })

  require("neoclip").setup({
    default_register = "+",
    enable_persistent_history = not Work,
    keys = {
      telescope = {
        i = {
          select = "<cr>",
          paste = "<c-y>p",
          paste_behind = "<c-y>P",
          replay = "<c-q>", -- replay a macro
          delete = "<c-d>", -- delete an entry
          custom = {},
        },
        n = {
          select = "<cr>",
          paste = "p",
          paste_behind = "P",
          replay = "q",
          delete = "d",
          custom = {},
        },
      },
    },
  })

  require("telescope").load_extension("fzf")
  require("telescope").load_extension("git_worktree")
  require("telescope").load_extension("neoclip")
  require("telescope").load_extension("file_browser")
  require("telescope").load_extension("live_grep_args")
  require("telescope").load_extension("undo")
  require("telescope").load_extension("lazy")

  vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
      if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
          "i",
          false
        )
      end
    end,
  })
end

return M
