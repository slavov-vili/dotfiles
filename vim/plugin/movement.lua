-- Put mini.bracketed as high as possible, because others overwrite its mappings (e.g. mini.indentscope defines a mapping for "[i")
require('mini.bracketed').setup({
    buffer     = { suffix = 'b', options = { add_to_jumplist = true } },
    comment    = { suffix = 'c', options = { add_to_jumplist = true } },
    conflict   = { suffix = 'x', options = { add_to_jumplist = true } },
    diagnostic = { suffix = 'd', options = { add_to_jumplist = true } },
    file       = { suffix = 'f', options = { add_to_jumplist = true } },
    indent     = { suffix = 'i', options = { add_to_jumplist = true } },
    jump       = { suffix = 'j', options = { add_to_jumplist = true } },
    location   = { suffix = 'l', options = { add_to_jumplist = true } },
    oldfile    = { suffix = 'o', options = { add_to_jumplist = true } },
    quickfix   = { suffix = 'q', options = { add_to_jumplist = true } },
    treesitter = { suffix = 't', options = { add_to_jumplist = true } },
    undo       = { suffix = 'u', options = { add_to_jumplist = true } },
    window     = { suffix = 'w', options = { add_to_jumplist = true } },
    yank       = { suffix = 'y', options = { add_to_jumplist = true } },
})



local hop = require('hop')
hop.setup{
    extensions = { 'hop-yank', 'hop-treesitter' }
}

local function current_line(action)
    return function()
        action({current_line_only = true})
    end
end

local function multi_windows(action)
    return function()
        action({ multi_windows = true })
    end
end

local PREFIX = '<leader>h'
local function map(key, action, opts, mode)
    mode = mode or {'n', 'x'}
    vim.keymap.set(mode, PREFIX..key, action, vim.tbl_extend("force", { remap=true }, opts))
end



-- Hop anywhere
map('a', current_line(hop.hint_anywhere), { desc = "Jump anywhere in current line" })
map('A', hop.hint_anywhere, { desc = "Jump anywhere" })
-- map('A', multi_windows(hop.hint_anywhere), { desc = "Jump anywhere (multi_windows)" })
-- Hop to character
map('f', current_line(hop.hint_char1), { desc = "Jump to char in current line" })
map('F', hop.hint_char1, { desc = "Jump to char anywhere" })
map('c', multi_windows(hop.hint_char1), { desc = "Jump to char anywhere (multi_windows)" })
map('t', current_line(hop.hint_char2), { desc = "Jump to 2 chars in current line" })
map('T', hop.hint_char2, { desc = "Jump to 2 chars anywhere" })
map('C', multi_windows(hop.hint_char2), { desc = "Jump to 2 chars anywhere (multi_windows)" })
-- Hop to word
map('w', current_line(hop.hint_words), { desc = "Jump to word in current line" })
map('W', hop.hint_words, { desc = "Jump to word anywhere" })
map('M', multi_windows(hop.hint_words), { desc = "Jump to word anywhere (multi_windows)" })
-- Hop to pattern
map('/', hop.hint_patterns, { desc = "Jump to search pattern" })
map('?', multi_windows(hop.hint_patterns), { desc = "Jump to search pattern (multi_windows)" })
-- Hop to line
map('l', hop.hint_lines_skip_whitespace, { desc = "Jump to line (skip_whitespace)" })
map('L', multi_windows(hop.hint_lines_skip_whitespace), { desc = "Jump to line (skip_whitespace, multi_windows)" })
map('0', hop.hint_lines, { desc = "Jump to line" })
map(')', multi_windows(hop.hint_lines), { desc = "Jump to line (multi_windows)" })
map('v', hop.hint_vertical, { desc = "Jump vertically" })
map('V', multi_windows(hop.hint_vertical), { desc = "Jump vertically (multi_windows)" })



-- FIXME: this stuff requires extensions
-- Yank from char to char
-- map('y', current_line(hop.yank_char1), { desc = "Yank from char to char in current line" })
-- map('Y', hop.yank_char1, { desc = "Yank from char to char anywhere" })
-- -- Paste to char
-- map('p', current_line(hop.paste_char1), { desc = "Paste to char in current line" })
-- map('P', hop.paste_char1, { desc = "Paste to char anywhere" })



-- -- Hop to TreeSitter node
-- map('n', hop.hint_nodes, { desc = "Jump to node" })

