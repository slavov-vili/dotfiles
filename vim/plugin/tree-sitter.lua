local ts_select = require("nvim-treesitter-textobjects.select")
local ts_swap = require("nvim-treesitter-textobjects.swap")
local ts_move = require("nvim-treesitter-textobjects.move")

-- TODO: create a setting for auto-installing and add it to the FilyType autocmd?

local auto_install = true

vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    local buf = event.buf
    local ft = vim.bo[buf].filetype

    if ft == "" or vim.bo[buf].buftype ~= "" then
      return
    end

    local lang = vim.treesitter.language.get_lang(ft) or ft

    if auto_install then
      vim.cmd("TSInstall " .. lang)
    end

    local has_parser = pcall(vim.treesitter.language.add, lang)

    if not has_parser then
      return
    end

    vim.treesitter.start()

    vim.bo[buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"

    local win = vim.api.nvim_get_current_win()
    vim.wo[win].foldmethod = "expr"
    vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
})


local PREFIX = '<leader>c'
local function map(key, action, desc, mode)
  mode = mode or "n"
  vim.keymap.set(mode, key, action, { noremap = true, silent = true, desc = desc })
end

--
-- Selects
--
local function map_select(key, desc, query_string, query_group)
  map(key, function()
    ts_select.select_textobject(query_string, query_group or "textobjects")
  end, desc, { "x", "o" })
end
map_select("ac", "Select around class",    "@class.outer")
map_select("ic", "Select inside class",    "@class.inner")

map_select("af", "Select around function", "@function.outer")
map_select("if", "Select inside function", "@function.inner")

map_select("aa", "Select around argument", "@parameter.outer")
map_select("ia", "Select inside argument", "@parameter.inner")

-- You can also use captures from other query groups like `locals.scm`
-- TODO: figure out why locals isn't in the nvim folder
map_select("aS", "Select around scope",    "@local.scope", "locals")

-- TODO: define other selects?



--
-- Swaps
--
local function map_swap(key, desc, action, query_string)
  map(PREFIX .. key, function() ts_swap[action](query_string) end, desc)
end
map_swap("a", "Swap argument with next one",     "swap_next",     "@parameter.inner")
map_swap("A", "Swap Argument with next one",     "swap_next",     "@parameter.outer")
map_swap("q", "Swap argument with previous one", "swap_previous", "@parameter.inner")
map_swap("Q", "Swap argument with previous one", "swap_previous", "@parameter.outer")

map_swap("f", "Swap Function with next one",     "swap_next",     "@function.outer")
map_swap("F", "Swap function with next one",     "swap_next",     "@function.inner")
map_swap("r", "Swap Function with previous one", "swap_previous", "@function.outer")
map_swap("R", "Swap function with previous one", "swap_previous", "@function.inner")

-- TODO: define other swaps?
-- TODO: deine custom swap for the body of an if and its else



--
-- Movement
--
-- TODO: Add mappings for moving between objects
