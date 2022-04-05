local utils = require("utils")
local nnoremap = utils.nnoremap
local vnoremap = utils.vnoremap
local silent = { silent = true }
local sexpr = { silent = true, expr = true }

vim.cmd([[command W :w]])
vim.cmd([[command Q :q]])
vim.cmd([[command Wq :wq]])

nnoremap("<CR>", ":nohl<CR>")

-- paste/delete and keep register clean
vnoremap("<leader>p", '"_dP')
vnoremap("<leader>d", '"_d')

-- better indenting
vnoremap("<", "<gv", silent)
vnoremap(">", ">gv", silent)

-- easier exit insert mode in the terminal
utils.tnoremap("<Esc>", "<C-\\><C-n>")

-- keeps jumps centered
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("<leader>J", "mzJ`z")

nnoremap("<leader>pp", ":echo expand('%:p')<CR>")
nnoremap("<leader>ss", ":lua require('utils').save_and_source()<CR>")

nnoremap("<leader>fr", ":norm! V<CR> :s/") -- quick find & replace
vnoremap("<leader>fr", ":s/") -- quick find & replace

------------------------                  -------------------------
------------------------ Plugin Specifics -------------------------
------------------------                  -------------------------

-- format code
nnoremap("<leader>fm", ":lua vim.lsp.buf.formatting()<CR>")
vnoremap("<leader>fm", ":lua vim.lsp.buf.range_formatting()<CR>")

-- Telescope
nnoremap("<C-p>", ":lua require('jtelescope').project_files()<CR>")
nnoremap("<C-e>", ":Telescope file_browser<CR>", silent)
nnoremap("<leader>fw", ":Telescope live_grep<CR>", silent)
nnoremap("<leader>gc", ":Telescope git_commits<CR>", silent)
nnoremap("<leader>fb", ":Telescope buffers<CR>", silent)
nnoremap("<leader>fh", ":Telescope help_tags<CR>", silent)
nnoremap("<leader>rc", ":lua require'jtelescope'.search_dotfiles()<CR>", silent)
nnoremap("<leader>fg", ":lua require'jtelescope'.git_worktrees()<CR>", silent)
nnoremap("<leader>ct", ":lua require'jtelescope'.create_git_worktree()<CR>", silent)
nnoremap("<leader>fy", ":lua require'jtelescope'.neoclip()<CR>", silent)
nnoremap("<leader>ff", ":lua require'jtelescope'.curbuf()<CR>", silent)
nnoremap("<leader>fc", ":Telescope commands<CR>", silent)
nnoremap("<leader>gh", ":lua require'jtelescope'.git_hunks()<CR>", silent)

-- Lsp
nnoremap("gD", ":lua vim.lsp.buf.declaration()<CR>", silent)
nnoremap("K", ":lua vim.lsp.buf.hover()<CR>", silent)
nnoremap("<C-k>", ":lua vim.lsp.buf.signature_help()<CR>", silent)
nnoremap("<leader>D", ":lua vim.lsp.buf.type_definition()<CR>", silent)
nnoremap("<leader>rn", ":lua vim.lsp.buf.rename()<CR>", silent)
nnoremap("<leader>d", ":lua vim.diagnostic.open_float()<CR>", silent)
-- Lsp Tele
nnoremap("gd", ":Telescope lsp_definitions<CR>", silent)
nnoremap("gr", ":Telescope lsp_references<CR>", silent)
nnoremap("<leader>ca", ":lua require('jtelescope').lsp_code_actions()<CR>", silent)
nnoremap("<leader>gi", ":Telescope lsp_implementations<CR>", silent)
nnoremap("<leader>fs", ":lua require('jtelescope').get_symbols()<CR>", silent)
nnoremap("<leader>td", ":Telescope diagnostics bufnr=0<CR>", silent)
nnoremap("<leader>tw", ":Telescope diagnostics<CR>", silent)

-- Harpoon
nnoremap("<leader>a", ":lua require'harpoon.mark'.add_file()<CR>", silent)
nnoremap("<leader>e", ":lua require'harpoon.ui'.toggle_quick_menu({ mark = true })<CR>", silent)
nnoremap("<leader>o", ":lua require'harpoon.ui'.toggle_quick_menu({ mark = false })<CR>", silent)

nnoremap("<leader>hn", ":lua require('harpoon.ui').nav_file(1)<CR>")
nnoremap("<leader>he", ":lua require('harpoon.ui').nav_file(2)<CR>")
nnoremap("<leader>ho", ":lua require('harpoon.ui').nav_file(3)<CR>")
nnoremap("<leader>hi", ":lua require('harpoon.ui').nav_file(4)<CR>")

nnoremap("<leader>tn", ":lua require('harpoon.term').gotoTerminal(1)<CR>")
nnoremap("<leader>te", ":lua require('harpoon.term').gotoTerminal(2)<CR>")

-- git wrapper
if Work then
  nnoremap("<leader>gs", ":tab G<CR>", silent)
else
  nnoremap("<leader>gs", ":Neogit<CR>", silent)
end

-- Hop
nnoremap("<leader><leader>b", ":HopWordBC<CR>")
nnoremap("<leader><leader>w", ":HopWordAC<CR>")

-- undotree
nnoremap("<leader>u", ":UndotreeShow<CR>", silent)

-- symbols
nnoremap("<leader>so", ":SymbolsOutline<CR>", silent)

-- luasnips
vim.cmd([[
  imap <silent><expr> <C-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-k>'
  inoremap <silent> <C-j> <Cmd>lua require('luasnip').jump(-1)<CR>
  imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'
  snoremap <silent> <C-k> <Cmd>lua require('luasnip').jump(1)<CR>
  snoremap <silent> <C-j> <Cmd>lua require('luasnip').jump(-1)<CR>
]])

-- gomove
utils.imap("<A-h>", "<Esc>:lua require('gomove.mappings.base').MoveLineHorizontal(-vim.v.count1)<CR>i")
utils.imap("<A-j>", "<Esc>:lua require('gomove.mappings.base').MoveLineVertical(vim.v.count1)<CR>i")
utils.imap("<A-k>", "<Esc>:lua require('gomove.mappings.base').MoveLineVertical(-vim.v.count1)<CR>i")
utils.imap("<A-l>", "<Esc>:lua require('gomove.mappings.base').MoveLineHorizontal(vim.v.count1)<CR>i")

-- plenary
vim.cmd("nmap <leader>pt <Plug>PlenaryTestFile")
