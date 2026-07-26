-- Because nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- TODO: check plugin configs (pear-tree kinda slow, do I need sleuth?, configure fzf?)
-- [Plugin setup]
local GITHUB = 'https://github.com'
vim.pack.add({
    -- Movement
    { src = GITHUB .. '/smoka7/hop.nvim' },
    { src = GITHUB .. '/echasnovski/mini.bracketed' },
    -- Editing
    { src = GITHUB .. '/tmsvg/pear-tree' },
    { src = GITHUB .. '/tpope/vim-surround' },
    { src = GITHUB .. '/echasnovski/mini.ai' },
    -- Completion
    { src = GITHUB .. '/hrsh7th/cmp-buffer' },
    { src = GITHUB .. '/hrsh7th/cmp-cmdline' },
    { src = GITHUB .. '/hrsh7th/cmp-nvim-lsp' },
    { src = GITHUB .. '/hrsh7th/cmp-path' },
    { src = GITHUB .. '/hrsh7th/nvim-cmp' },
    -- Files
    { src = GITHUB .. '/chrisgrieser/nvim-genghis' },
    { src = GITHUB .. '/nvim-tree/nvim-tree.lua' },
    -- Git
    { src = GITHUB .. '/lewis6991/gitsigns.nvim' },
    { src = GITHUB .. '/tpope/vim-fugitive' },
    -- LSP
    { src = GITHUB .. '/williamboman/mason.nvim' },
    { src = GITHUB .. '/neovim/nvim-lspconfig' },
    { src = GITHUB .. '/williamboman/mason-lspconfig.nvim' },
    -- Treesitter
    { src = GITHUB .. '/nvim-treesitter/nvim-treesitter' },
    { src = GITHUB .. '/nvim-treesitter/nvim-treesitter-textobjects' },
    -- Visual
    { src = GITHUB .. '/echasnovski/mini.animate' },
    { src = GITHUB .. '/echasnovski/mini.trailspace' },
    { src = GITHUB .. '/itchyny/lightline.vim' },
    { src = GITHUB .. '/luochen1990/rainbow' },
    { src = GITHUB .. '/nvim-tree/nvim-web-devicons' },
    { src = GITHUB .. '/slavov-vili/nvim-scopemaster' },
    -- Others
    { src = GITHUB .. '/ibhagwan/fzf-lua', version = 'main' },
    { src = GITHUB .. '/nvimtools/hydra.nvim' },
    { src = GITHUB .. '/tpope/vim-sleuth' },
    { src = GITHUB .. '/folke/which-key.nvim' },
})
vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")

vim.cmd("syntax on") -- Enable syntax highlighting
vim.cmd("filetype plugin indent on") -- Use auto-indenting

-- [Set GUI-specific settings]
if vim.fn.has("gui_running") == 1 then
    vim.cmd.colorscheme("obsidian2") -- Set GUI color scheme
else
    vim.cmd.colorscheme("welpe")     -- Set color scheme
end



-- [Settings]
vim.opt.autoindent=true                    -- Follow indentation of last line
vim.opt.autoread=true                      -- Auto-detect file changes
vim.opt.autowrite=true                     -- Auto-save file before running
vim.opt.backupdir="~/.backup,.,/tmp"       -- Do not put backups in current dir
vim.opt.breakindent=true                   -- Indent the text when wrapping
vim.opt.cmdheight=2                        -- Height of the command bar
vim.opt.completeopt="longest,menuone"      -- Auto-completion option menu
vim.opt.confirm=true                       -- Confirm :q when unsaved changes
vim.opt.cursorline=true                    -- Highlight current line
vim.opt.diffopt="internal,filler,closeoff,algorithm:patience"
vim.opt.directory="~/.backup,.,/tmp"       -- Don't put swaps in current dir
vim.opt.equalalways=true                   -- Make all windows equal in size
vim.opt.encoding="utf-8"
vim.opt.expandtab=true                     -- Replace tabs with spaces (overwritten by vim-sleuth)
vim.opt.fileencoding="utf-8"
vim.opt.fileformat="unix"
vim.opt.foldenable=true                    -- Enable folding
vim.opt.foldcolumn="4"                     -- Width of column indicating folds
vim.opt.foldlevelstart=99                  -- No closed folds at start
vim.opt.foldmethod="indent"                -- Auto-folding of indented blocks
vim.opt.foldnestmax=5                      -- Maximum number of nested folds
vim.opt.helplang="en"                      -- Set help language to English
vim.opt.hlsearch=true                      -- Highlight search results
vim.opt.ignorecase=true                    -- Ignore case when searching
vim.opt.incsearch=true                     -- HL search matches while typing
vim.opt.laststatus=3                       -- Always show statusline
vim.opt.lazyredraw=true                    -- Redraw screen only when need to
vim.opt.linebreak=true                     -- Don't split words when wrapping
vim.opt.list=true
vim.opt.listchars="tab:> ,eol:¬"           -- Set Tab and EOL characters
vim.opt.mouse="a"                          -- Enable mouse in all modes
vim.opt.bomb=false                         -- No BOM
vim.opt.errorbells=false
vim.opt.visualbell=true
vim.opt.swapfile=false                     -- Disable swap files
vim.opt.number=true                        -- Turn on line numbers
vim.opt.omnifunc="syntaxcomplete#Complete" -- Native auto-complete
vim.opt.scroll=10
vim.opt.scrolloff=7
vim.opt.shell="/bin/bash"                  -- Set the default shell
vim.opt.shellcmdflag="-ic"                 -- Make vim read my .bashrc (I just love my aliases too much)
vim.opt.shiftwidth=4                       -- Indentation size (overwritten by vim-sleuth)
vim.opt.showcmd=true                       -- Show incomplete commands (fd, cw, etc.)
vim.opt.showmatch=true                     -- Highlight matching brackets
vim.opt.signcolumn="auto:2"                -- Show up to 2 signs
vim.opt.smartcase=true                     -- Respect capital letters in searches
vim.opt.smartindent=true                   -- Use smart indentation
vim.opt.smarttab=true                      -- Use smart tabs (overwritten by vim-sleuth)
vim.opt.splitbelow=true                    -- New splits always below
vim.opt.splitright=true                    -- New vSplits always to the right"
vim.opt.tabstop=4
vim.opt.updatetime=1000                    -- Write after this many miliseconds of being idle
vim.opt.wildmenu=true                      -- Better auto-completion for cmd
vim.g.mapleader=","                        -- Change leader key



-- [Highlighting]
-- WARNING: this assumes that the used font is dark (elflord)
vim.api.nvim_set_hl(0, "CursorLine", {
    cterm = { bold = true },
    bg = "#404040"
})
-- TODO: also set for gui
vim.api.nvim_set_hl(0, "DiffChange", {
    ctermbg = "NONE"
})
vim.api.nvim_set_hl(0, "DiffText", {
    ctermbg = 100
})
vim.api.nvim_set_hl(0, "DiffDelete", {
    ctermbg = 52
})



-- [Key mappings]
local all_modes = {"n", "v", "o"}
local function map(l, r, opts, mode)
    mode = mode or "n"
    opts = opts or {}
    vim.keymap.set(mode, l, r, opts)
end

-- gg => END
map("G", "gg", { desc = "Go to file end"},   all_modes)
map("gg", "G", { desc = "Go to file start"}, all_modes)
-- Optical illusion?
map("P", "p",  { desc = "Paste after cursor"},  all_modes)
map("p", "P",  { desc = "Paste before cursor"}, all_modes)
map("<leader>`", ":set rnu!<cr>",                         { desc = "Toggle relative line numbers"},    all_modes)
map("<leader><leader>", ":set cursorcolumn!<cr>",         { desc = "Toggle highlight current column"}, all_modes)
-- I found it, now go away!
map("<leader><space>", ":nohlsearch<cr>",                 { desc = "Clear search highlighting"})
map("<leader>en", ":setlocal spell! spelllang=en_us<cr>", { desc = "Toggle spellchecker English"})
map("<leader>de", ":setlocal spell! spelllang=de_de<cr>", { desc = "Toggle spellchecker German"})
map("<leader>bg", ":setlocal spell! spelllang=bg_bg<cr>", { desc = "Toggle spellchecker Bulgarian"})
map("<leader>r", ":Run<cr>",                              { desc = "Run current file"},   all_modes)
map("<leader>o", ":Open<cr>",                             { desc = "Open current file?"}, all_modes)
map("<leader><F5>", ":so $MYVIMRC<cr>",                   { desc = "Reload vimrc"},       all_modes)

-- Visual mode mappings
map(">", ">gv", { desc = "Reopen visual mode after indent"},   "v")
map("<", "<gv", { desc = "Reopen visual mode after unindent"}, "v")

-- Insert mode mappings
map("<C-space>", "<C-x><C-o>",                       { desc = "Omni-completion in insert mode"}, "i")
map("<CR>", 'pumvisible() ? "\\<C-y>" : "\\<CR>"',   { desc = "Choose popup menu also with Enter (instead of only Ctrl-Y", expr = true }, "i")
map("<Esc>", 'pumvisible() ? "\\<C-e>" : "\\<Esc>"', { expr = true, desc = "Close popup menu like other modes"}, "i")
-- Terminal mode mappings
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
  end,
})
map("<Esc>", "<C-\\><C-n>",                { desc = "Go back to normal mode form terminal mode"}, "t")
map("<leader>;", ":split term://bash<cr>", { desc = "Open terminal"},                             "n")

map("<leader>:", "yy:@\"<cr>",    { desc = "Execute line under cursor as vim command"}, "n")
map("<leader>:", "y:@\"<cr>",     { desc = "Execute selection as vim command"},         "v")

-- Tab manipulation
map("<Tab>n", " :tabnew ",        { desc = "New tab"},               "n")
map("<Tab>o", " :tabonly<cr>",    { desc = "Only keep this tab"},    "n")
map("<Tab>j", " gT",              { desc = "Go to previous tab"},    "n")
map("<Tab>k", " gt",              { desc = "Go to next tab"},        "n")
map("<Tab>J", " :tabfirst<cr>",   { desc = "Go to first tab"},       "n")
map("<Tab>K", " :tablast<cr>",    { desc = "Go to last tab"},        "n")
map("<Tab>mj", ":tabmove -1<cr>", { desc = "Move tab to the left"},  "n")
map("<Tab>mk", ":tabmove +1<cr>", { desc = "Move tab to the right"}, "n")
map("<Tab>c", " :tabclose<cr>",   { desc = "Close tab"}, "n")

-- Window manipulation
map("<leader>s", ":split ",  { desc = "Horizontal split"},       "n")
map("<leader>v", ":vsplit ", { desc = "Vertical split"},         "n")
map("<C-W><Tab>", "<C-W>T",  { desc = "Move window to new tab"}, "n")

