local fzf = require("fzf-lua")

fzf.setup({
  winopts = {
    height     = 0.90,
    width      = 0.90,
    row        = 0.5,
    col        = 0.5,
    preview = {
      layout   = "flex", -- Swaps between horizontal/vertical depending on screen size
      horizontal = "right:55%",
      vertical = "down:50%",
    },
  },
  previewers = {
    builtin = {
      syntax = true,
      extensions = {
        ["jpg"] = { "viu", "-b" },
        ["png"] = { "viu", "-b" },
        ["svg"] = { "chafa", "{file}" },
      },
      ueberzug_scaler = "cover",
    }
  },
  keymap = {
    builtin = {
      -- Finder Window Mechanics
      ["<C-z>"] = "hide",
      ["<C-h>"] = "toggle-help",
      ["<C-f>"] = "toggle-fullscreen",

      -- Preview Window Toggles
      ["<C-p>"] = "toggle-preview",
      ["<C-l>"] = "toggle-preview-wrap",
      ["<C-o>"] = "toggle-preview-cw",
      ["<C-y>"] = "toggle-preview-behavior",
      ["<C-r>"] = "preview-reset",
      ["<C-j>"] = "down",
      ["<C-k>"] = "up",

      -- Preview Navigation
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
      -- ["<C-j>"] = "preview-down",
      -- ["<C-k>"] = "preview-up",

      -- Treesitter-Context
      -- ["<C-T>"] = "toggle-preview-ts-ctx",
      -- ["<C-[>"] = "preview-ts-ctx-dec",
      -- ["<C-]>"] = "preview-ts-ctx-inc",
    },

    fzf = {
      -- General Control
      ["ctrl-q"] = "abort",
      ["ctrl-x"] = "toggle+down",
      ["ctrl-space"] = "toggle-all",

      -- Edit Text Input
      ["ctrl-b"] = "beginning-of-line",
      ["ctrl-e"] = "end-of-line",
      ["ctrl-w"] = "unix-line-discard",
      -- Scroll list navigation
      -- ["ctrl-f"] = "half-page-down",
      -- ["ctrl-d"] = "half-page-up",
      -- Jumping
      ["ctrl-i"] = "first",
      ["ctrl-n"] = "last",
    },
  },

  actions = {
    -- Below are the default actions, setting any value in these tables will override
    -- the defaults, to inherit from the defaults change [1] from `false` to `true`
    files = {
      -- true,        -- uncomment to inherit all the below in your custom config
      -- Pickers inheriting these actions:
      --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
      --   tags, btags, args, buffers, tabs, lines, blines
      -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
      -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
      -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
      ["enter"]     = FzfLua.actions.file_edit_or_qf,
      ["ctrl-s"]    = FzfLua.actions.file_split,
      ["ctrl-v"]    = FzfLua.actions.file_vsplit,
      ["ctrl-t"]    = FzfLua.actions.file_tabedit,
      ["ctrl-q"]    = FzfLua.actions.file_sel_to_qf,
      ["alt-q"]     = FzfLua.actions.file_sel_to_ll,
      ["alt-i"]     = FzfLua.actions.toggle_ignore,
      ["alt-h"]     = FzfLua.actions.toggle_hidden,
      ["alt-f"]     = FzfLua.actions.toggle_follow,
    },
  },
  files = {
    git_icons = true,
    file_icons = true,
    color_icons = true,
  },
  grep = {
    rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case",
  },
})

local PREFIX = '<leader>f'
local function map(key, action, opts, mode)
  mode = mode or "n"
  vim.keymap.set(mode, PREFIX..key, action, vim.tbl_extend("force", { noremap = true, silent = true }, opts))
end



-- Files
map(":", fzf.lines,          { desc = "Search All Buffer Lines" })
map(";", fzf.blines,         { desc = "Search Current Buffer Lines" })
map("L", fzf.loclist_stack,  { desc = "Search Location Stack" })
map("Q", fzf.quickfix_stack, { desc = "Search Quickfix Stack" })
map("T", fzf.treesitter,     { desc = "Search Treesitter Symbols" })
map("a", fzf.args,           { desc = "Search Arg List" })
map("b", fzf.buffers,        { desc = "Search Open Buffers" })
map("f", fzf.files,          { desc = "Search Find Files" })
map("l", fzf.loclist,        { desc = "Search Location List" })
map("o", fzf.oldfiles,       { desc = "Search Recent Files" })
map("q", fzf.quickfix,       { desc = "Search Quickfix List" })
map("t", fzf.tabs,           { desc = "Search Tabs" })



-- Search
map("/", fzf.grep_curbuf,    { desc = "Search Grep Current Buffer" })
map("G", fzf.grep,           { desc = "Search Grep" })
map("L", fzf.grep_last,      { desc = "Search Repeat Last Grep" })
map("Q", fzf.grep_quickfix,  { desc = "Search Grep Quickfix" })
map("W", fzf.grep_cWORD,     { desc = "Search Grep WORD Under Cursor" })
map("g", fzf.live_grep,      { desc = "Search Live Grep" })
map("l", fzf.lgrep_loclist,  { desc = "Search Live Grep Loclist" })
map("p", fzf.grep_project,   { desc = "Search Grep Project" })
map("q", fzf.lgrep_quickfix, { desc = "Search Live Grep Quickfix" })
map("w", fzf.grep_cword,     { desc = "Search Grep Word Under Cursor" })
map("g", fzf.grep_visual,    { desc = "Search Grep Visual Selection" }, "v")
-- TODO find other stuff here



-- Git
map("gS", fzf.git_stash,    { desc = "Search Git Stash" })
map("gb", fzf.git_branches, { desc = "Search Git Branches" })
map("gc", fzf.git_commits,  { desc = "Search Git Commits" })
map("gd", fzf.git_diff,     { desc = "Search Git Diff" })
map("gs", fzf.git_status,   { desc = "Search Git Status" })
map("gt", fzf.git_tags,     { desc = "Search Git Tags" })



-- LSP
map("lC", fzf.lsp_incoming_calls,         { desc = "Search LSP Incoming Calls" })
map("lD", fzf.lsp_declarations,           { desc = "Search LSP Declarations" })
map("lS", fzf.lsp_workspace_symbols,      { desc = "Search Workspace Symbols" })
map("lT", fzf.lsp_type_super,             { desc = "Search LSP Supertypes" })
map("lX", fzf.diagnostics_workspace,      { desc = "Search Workspace Diagnostics" })
map("la", fzf.lsp_code_actions,           { desc = "Search LSP Code Actions" })
map("lc", fzf.lsp_outgoing_calls,         { desc = "Search LSP Outgoing Calls" })
map("ld", fzf.lsp_definitions,            { desc = "Search LSP Definitions" })
map("lf", fzf.lsp_finder,                 { desc = "Search LSP Finder" })
map("li", fzf.lsp_implementations,        { desc = "Search LSP Implementations" })
map("ll", fzf.lsp_live_workspace_symbols, { desc = "Search Live Workspace Symbols" })
map("lr", fzf.lsp_references,             { desc = "Search LSP References" })
map("ls", fzf.lsp_document_symbols,       { desc = "Search Document Symbols" })
map("ls", fzf.lsp_type_sub,               { desc = "Search LSP Subtypes" })
map("lt", fzf.lsp_typedefs,               { desc = "Search LSP Type Definitions" })
map("lx", fzf.diagnostics_document,       { desc = "Search Document Diagnostics" })



-- Miscellaneous
map("R",  fzf.resume,          { desc = "Search Resume Last Picker" })
map("B",  fzf.builtin,         { desc = "Search Builtin Pickers" })
map("P",  fzf.profiles,        { desc = "Search Profiles" })
map("`",  fzf.marks,           { desc = "Search Marks" })
map("J",  fzf.jumps,           { desc = "Search Jumps" })
map("c",  fzf.commands,        { desc = "Search Commands" })
map("h",  fzf.command_history, { desc = "Search Command History" })
map("~",  fzf.changes,         { desc = "Search Changes" })
map("\"", fzf.registers,       { desc = "Search Registers" })
map("]",  fzf.tagstack,        { desc = "Search Tag Stack" })
map("H",  fzf.helptags,        { desc = "Search Help Tags" })
map("M",  fzf.manpages,        { desc = "Search Man Pages" })
map("C",  fzf.colorschemes,    { desc = "Search Color Schemes" })
map("?",  fzf.search_history,  { desc = "Search Search History" })
map("K",  fzf.keymaps,         { desc = "Search Keymaps" })
map("O",  fzf.nvim_options,    { desc = "Search Neovim Options" })
map("F",  fzf.filetypes,       { desc = "Search Filetypes" })
map("N",  fzf.menus,           { desc = "Search Menus" })
-- TODO: do I even need this?
map("sp", fzf.spellcheck,     { desc = "Search Spellcheck Words" })
map("ss", fzf.spell_suggest,  { desc = "Search Spell Suggestions" })
map("Ep", fzf.packadd,        { desc = "Search Packadd Plugins" })
map("Eh", fzf.highlights,     { desc = "Search Highlights" })
map("Ea", fzf.autocmds,       { desc = "Search Auto-commands" })
map("Et", fzf.tmux_buffers,   { desc = "Search Tmux Buffers" })
map("Ez", fzf.zoxide,         { desc = "Search Zoxide Directories" })



-- Completion
map("cp", fzf.complete_path,  { desc = "Search Complete Path" })
map("cf", fzf.complete_file,  { desc = "Search Complete File" })
map("cl", fzf.complete_bline, { desc = "Search Complete Buffer Line" })
map("cL", fzf.complete_line,  { desc = "Search Complete Line" })

