local M = {}
local utils = require("utils")
local colors = require("themes.onedark").colors
local Path = require("plenary.path")

local mode_color = function()
  local mode_colors = {
    n = colors.nord_blue,
    i = colors.green,
    c = colors.white,
    V = colors.blue,
    [""] = colors.blue,
    v = colors.blue,
    R = colors.teal,
    s = colors.dark_purple,
  }
  local color = mode_colors[vim.fn.mode()]
  if color == nil then
    color = colors.red
  end
  return color
end

M.config = function()
  local gl = require("galaxyline")
  local gls = gl.section
  local condition = require("galaxyline.condition")

  gl.short_line_list = { "Outline", }

  gls.left[1] = {
    ViModeSeparator1 = {
      provider = function()
        vim.cmd("hi GalaxyViModeSeparator1 guifg=" .. mode_color())
        vim.cmd("hi GalaxyViModeSeparator1 guibg=" .. mode_color())
        return "▋"
      end,
      highlight = { colors.nord_blue, colors.statusline_bg },
    },
  }

  gls.left[2] = {
    ViMode = {
      provider = function()
        local alias = {
          n = "Normal",
          i = "Insert",
          c = "Command",
          V = "Visual",
          [""] = "Visual",
          v = "Visual",
          R = "Replace",
          s = "Select",
        }
        local current_mode = alias[vim.fn.mode()]
        vim.cmd("hi GalaxyViMode guibg=" .. mode_color())

        if current_mode == nil then
          print(vim.fn.mode())
          return "  Terminal "
        else
          return "  " .. current_mode .. " "
        end
      end,
      highlight = { colors.statusline_bg, colors.nord_blue },
    },
  }

  gls.left[3] = {
    ViModeSeparator2 = {
      provider = function()
        vim.cmd("hi GalaxyViModeSeparator2 guifg=" .. mode_color())
        return "  "
      end,
      highlight = { colors.statusline_bg, colors.lightbg },
    },
  }

  gls.left[4] = {
    current_dir = {
      provider = function()
        local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
        return "  " .. dir_name .. " "
      end,
      highlight = { colors.grey_fg2, colors.lightbg2 },
      separator = " ",
      separator_highlight = { colors.lightbg2, colors.statusline_bg },
    },
  }

  local checkwidth = function()
    local squeeze_width = vim.fn.winwidth(0) / 2
    if squeeze_width > 30 then
      return true
    end
    return false
  end

  gls.left[5] = {
    DiffAdd = {
      provider = "DiffAdd",
      condition = checkwidth,
      icon = "+",
      highlight = { colors.base0B, colors.statusline_bg },
    },
  }

  gls.left[8] = {
    DiffModified = {
      provider = "DiffModified",
      condition = checkwidth,
      icon = "~",
      highlight = { colors.sun, colors.statusline_bg },
    },
  }

  gls.left[9] = {
    DiffRemove = {
      provider = "DiffRemove",
      condition = checkwidth,
      icon = "-",
      highlight = { colors.base08, colors.statusline_bg },
    },
  }

  gls.left[10] = {
    DiagnosticError = {
      provider = "DiagnosticError",
      icon = "  ",
      highlight = { colors.red, colors.statusline_bg },
    },
  }

  gls.left[11] = {
    DiagnosticWarn = {
      provider = "DiagnosticWarn",
      icon = "  ",
      highlight = { colors.yellow, colors.statusline_bg },
    },
  }

  gls.left[12] = {
    DiagnosticInfo = {
      provider = "DiagnosticInfo",
      icon = "  ",
      highlight = { colors.green, colors.statusline_bg },
    },
  }

  gls.left[13] = {
    DiagnosticHint = {
      provider = "DiagnosticHint",
      icon = "  ",
      highlight = { colors.purple, colors.statusline_bg },
    },
  }

  gls.left[14] = {
    lsp_status = {
      provider = function()
        local clients = vim.lsp.get_active_clients()
        if #clients == 0 then
          return " No LSP "
        else
          return ""
        end
      end,
      highlight = { colors.grey_fg2, colors.statusline_bg },
      condition = condition.buffer_not_empty,
    },
  }

  -- MIDDLE
  gls.mid[1] = {
    FileIcon = {
      provider = "FileIcon",
      condition = condition.buffer_not_empty,
      highlight = { colors.white, colors.statusline_bg },
    },
  }

  gls.mid[2] = {
    FileName = {
      provider = function()
        local filename = Path:new(vim.fn.expand("%:p")):make_relative(vim.loop.cwd())
        return filename
      end,
      condition = condition.buffer_not_empty,
      highlight = { colors.white, colors.statusline_bg },
    },
  }

  -- RIGHT SIDE
  gls.right[1] = {
    unsaved = {
      provider = function()
        local unsaved_cnt = utils.modified_buf_count()
        if unsaved_cnt > 0 then
          return "λ" .. unsaved_cnt
        end
      end,
      event = "BufEnter",
      highlight = { colors.grey_fg2, colors.statusline_bg },
    },
  }

  gls.right[3] = {
    GitIcon = {
      provider = function()
        return " "
      end,
      condition = require("galaxyline.condition").check_git_workspace,
      highlight = { colors.grey_fg2, colors.statusline_bg },
      separator = " ",
      separator_highlight = { colors.statusline_bg, colors.statusline_bg },
    },
  }

  gls.right[4] = {
    GitBranch = {
      provider = function()
        local branch = require("galaxyline.providers.vcs").get_git_branch()
        if #branch > 15 then
          branch = branch:sub(1, 15)
        end
        return branch .. " "
      end,
      condition = require("galaxyline.condition").check_git_workspace,
      highlight = { colors.grey_fg2, colors.statusline_bg },
    },
  }

  gls.right[8] = {
    some_icon = {
      provider = function()
        return ""
      end,
      separator_highlight = { colors.base0B, colors.lightbg },
      highlight = { colors.statusline_bg, colors.base0B },
    },
  }

  gls.right[9] = {
    line_percentage = {
      provider = function()
        local current_line = vim.fn.line(".")
        local total_line = vim.fn.line("$")
        local current_col = vim.fn.virtcol(".")
        local details = current_line .. ":" .. current_col .. " "

        if current_line == 1 then
          return "  Top " .. details
        elseif current_line == vim.fn.line("$") then
          return "  Bot " .. details
        end
        local result, _ = math.modf((current_line / total_line) * 100)
        return "  " .. result .. "% " .. details
      end,
      highlight = { colors.statusline_bg, colors.base0B },
    },
  }
end
return M
