local configs = {
  ["fidget"] = { text = { spinner = { "🙈", "🙉", "🙊" } }, timer = { spinner_rate = 250 } },
  ["nvim-autopairs"] = {},
  ["colorizer"] = {},
  ["gomove"] = {},
  ["neoclip"] = {},
  ["hop"] = { key = "tnhesoaiwfrudpclm" },
  ["scrollbar"] = {},
  ["nvim-tree"] = { hijack_netrw = false },
}

for plugin_name, config in pairs(configs) do
  local ok, plugin = pcall(require, plugin_name)
  if not ok then
    vim.notify(string.format("Plugin %s is not available", plugin_name), vim.log.levels.WARN)
  else
    plugin.setup(config)
  end
end