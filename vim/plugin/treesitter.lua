local nvim_ts = require("nvim-treesitter")
local ts_textobjects = require("nvim-treesitter-textobjects")
local ts_select = require("nvim-treesitter-textobjects.select")
local ts_swap = require("nvim-treesitter-textobjects.swap")
local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
local ts_move = require("nvim-treesitter-textobjects.move")



-- Configuration
local PREFIX = '<leader>c'
local autoinstall = true

ts_textobjects.setup({
  move = {
    set_jumps = true,
  }
})



local function setup_keybinds()
  local function map(mode, key, action, opts)
    mode = mode or "n"
    vim.keymap.set(mode, key, action, vim.tbl_extend('force', { silent = true }, opts))
  end

  --
  -- Selects
  --
  local function map_select(key, desc, query_string, query_group)
    map({ "x", "o" }, key, function()
        ts_select.select_textobject(query_string, query_group or "textobjects")
      end, { desc = desc }
    )
  end
  -- Classes
  map_select("aC", "Select around class",       "@class.outer")
  map_select("iC", "Select inside class",       "@class.inner")

  -- Functions
  map_select("af", "Select around function",    "@function.outer")
  map_select("if", "Select inside function",    "@function.inner")

  -- Parameters/Arguments
  map_select("aa", "Select around argument",    "@parameter.outer")
  map_select("ia", "Select inside argument",    "@parameter.inner")

  -- Calls
  map_select("ac", "Select around call",        "@call.outer")
  map_select("ic", "Select inside call",        "@call.inner")

  -- Assignments
  map_select("a=", "Select around assignment",  "@assignment.outer")
  map_select("i=", "Select inside assignment",  "@assignment.inner")
  map_select("aL", "Select assignment lhs",     "@assignment.lhs")
  map_select("aR", "Select assignment rhs",     "@assignment.rhs")

  -- Loops
  map_select("al", "Select around loop",        "@loop.outer")
  map_select("il", "Select inside loop",        "@loop.inner")

  -- Conditionals
  map_select("ai", "Select around conditional", "@conditional.outer")
  map_select("ii", "Select inside conditional", "@conditional.inner")

  -- You can also use captures from other query groups like `locals.scm`
  -- TODO: figure out why locals isn't in the nvim folder
  map_select("aS", "Select around scope",       "@local.scope", "locals")



  --
  -- Swaps
  --
  local function map_swap(key, desc, action, query_string)
    map("n", key, function() ts_swap[action](query_string) end, { desc = desc })
  end
  -- Functions
  map_swap(PREFIX .. "f", "Swap Function with next one",           "swap_next",     "@function.outer")
  map_swap(PREFIX .. "F", "Swap Function with previous one",       "swap_previous", "@function.outer")
  map_swap(PREFIX .. "b", "Swap function with next one",           "swap_next",     "@function.inner")
  map_swap(PREFIX .. "B", "Swap function with previous one",       "swap_previous", "@function.inner")

  -- Parameers/Arguments
  map_swap(PREFIX .. "a", "Swap argument with next one",           "swap_next",     "@parameter.inner")
  map_swap(PREFIX .. "A", "Swap Argument with next one",           "swap_next",     "@parameter.outer")
  map_swap(PREFIX .. "q", "Swap argument with previous one",       "swap_previous", "@parameter.inner")
  map_swap(PREFIX .. "Q", "Swap argument with previous one",       "swap_previous", "@parameter.outer")

  -- Calls
  map_swap(PREFIX .. "c", "Swap Call with next one",               "swap_next",     "@call.outer")
  map_swap(PREFIX .. "C", "Swap call with next one",               "swap_next",     "@call.inner")
  map_swap(PREFIX .. "d", "Swap Call with previous one",           "swap_previous", "@call.outer")
  map_swap(PREFIX .. "D", "Swap call with previous one",           "swap_previous", "@call.inner")

  -- Assignents
  map_swap(PREFIX .. "=", "Swap Assignment with next one",         "swap_next",     "@assignment.outer")
  map_swap(PREFIX .. "-", "Swap Assignment with previous one",     "swap_previous", "@assignment.outer")
  map_swap(PREFIX .. "l", "Swap assignment lhs with next one",     "swap_next",     "@assignment.lhs")
  map_swap(PREFIX .. "L", "Swap assignment lhs with previous one", "swap_previous", "@assignment.lhs")
  map_swap(PREFIX .. "r", "Swap assignment rhs with next one",     "swap_next",     "@assignment.rhs")
  map_swap(PREFIX .. "R", "Swap assignment rhs with previous one", "swap_previous", "@assignment.rhs")

  -- Control structure bodies
  map_swap(PREFIX .. "i", "Swap the body of an if with next one",       "swap_next",     "@control_structure_body")
  map_swap(PREFIX .. "e", "Swap the body of an else with previous one", "swap_previous", "@control_structure_body")



  --
  -- Movement
  --
  local function map_move(key, desc, action, query_strings, query_group)
    map({ "n", "x", "o" }, key,
      function() action(query_strings, query_group or "textobjects") end,
      { desc = desc }
    )
  end
  local function map_move_next(key, desc, query_strings, query_group)
    map_move(key, desc, ts_move.goto_next, query_strings, query_group)
  end
  local function map_move_prev(key, desc, query_strings, query_group)
    map_move(key, desc, ts_move.goto_previous, query_strings, query_group)
  end

  -- Classes
  map_move_next("]C", "Go to next Class start/end",           {"@class.outer", "@class.inner"})
  map_move_prev("[C", "Go to previous class start/end",       {"@class.outer", "@class.inner"})

  -- Functions
  map_move_next("]f", "Go to next Function start/end",        "@function.outer")
  map_move_next("]F", "Go to next function start/end",        "@function.inner")
  map_move_prev("[f", "Go to previous Function start/end",    "@function.outer")
  map_move_prev("[F", "Go to previous function start/end",    "@function.inner")

  -- Parameters/Arguments
  map_move_next("]a", "Go to next argument start/end",        {"@parameter.outer", "@parameter.inner"})
  map_move_prev("[a", "Go to previous argument start/end",    {"@parameter.outer", "@parameter.inner"})

  -- Calls
  map_move_next("]c", "Go to next call start/end",            {"@call.outer", "@call.inner"})
  map_move_prev("[c", "Go to previous call start/end",        {"@call.outer", "@call.inner"})

  -- Assignments
  map_move_next("]=", "Go to next assignment start/end",      {"@assignment.outer", "@assignment.inner"})
  map_move_prev("[=", "Go to previous assignment start/end",  {"@assignment.outer", "@assignment.inner"})
  map_move_next("]L", "Go to next assignment start/end",      "@assignment.lhs")
  map_move_prev("[L", "Go to previous assignment start/end",  "@assignment.lhs")
  map_move_next("]R", "Go to next assignment start/end",      "@assignment.rhs")
  map_move_prev("[R", "Go to previous assignment start/end",  "@assignment.rhs")

  -- Loops
  map_move_next("]w", "Go to next loop start/end",            {"@loop.outer", "@loop.inner"})
  map_move_prev("[w", "Go to previous loop start/end",        {"@loop.outer", "@loop.inner"})

  -- Conditionals
  map_move_next("]i", "Go to next conditional start/end",     {"@conditional.outer", "@conditional.inner"})
  map_move_prev("[i", "Go to previous conditional start/end", {"@conditional.outer", "@conditional.inner"})

  -- Others
  map_move_next("]S", "Go to next scope start/end",           "@local.scope", "locals")
  map_move_prev("]S", "Go to previous scope start/end",       "@local.scope", "locals")
  map_move_next("]Z", "Go to next fold start/end",            "@fold", "folds")
  map_move_prev("]Z", "Go to previous fold start/end",        "@fold", "folds")



  local function map_repeat_move(key, desc, action, opts)
    map({ "n", "x", "o" }, key, action,
      vim.tbl_extend('force', { desc = desc }, opts or {})
    )
  end
  map_repeat_move(";", "Repeat last move",           ts_repeat_move.repeat_last_move)
  map_repeat_move(",", "Repeat last move backwards", ts_repeat_move.repeat_last_move_opposite)

  -- Make builtin f, F, t, T also repeatable
  map_repeat_move("f", "Wrap builtin f movement", ts_repeat_move.builtin_f_expr, { expr = true })
  map_repeat_move("F", "Wrap builtin F movement", ts_repeat_move.builtin_F_expr, { expr = true })
  map_repeat_move("t", "Wrap builtin t movement", ts_repeat_move.builtin_t_expr, { expr = true })
  map_repeat_move("T", "Wrap builtin T movement", ts_repeat_move.builtin_T_expr, { expr = true })
end



local if_else_query_map = {
  {
    langs = { "c", "cpp", "java", "javascript", "typescript" },
    query = [[
      (if_statement consequence: (_) @control_structure_body)

      (if_statement alternative:
        (else_clause (_) @control_structure_body)
      )
    ]],
  },
  {
    langs = { "python" },
    query = [[
      (if_statement consequence: (_) @control_structure_body)

      (if_statement alternative:
        (elif_clause consequence: (_) @control_structure_body)
      )

      (if_statement alternative:
        (else_clause body: (_) @control_structure_body)
      )
    ]],
  },
  {
    langs = { "lua" },
    query = [[
      (if_statement consequence: (_) @control_structure_body)

      (if_statement alternative:
        (elseif_statement consequence: (_) @control_structure_body)
      )

      (if_statement alternative:
        (else_statement body: (_) @control_structure_body)
      )
    ]],
  },
  {
    langs = { "go", "c_sharp" },
    query = [[
      (if_statement consequence: (_) @control_structure_body)

      (if_statement alternative: (_) @control_structure_body)
    ]],
  },
  {
    langs = { "rust" },
    query = [[
      (if_expression consequence: (_) @control_structure_body)

      (if_expression alternative:
        (else_clause (_) @control_structure_body)
      )
    ]],
  },
  {
    langs = { "bash" },
    query = [[
      (if_statement
        (command (_)+ @control_structure_body)
      )

      (if_statement
        (elif_clause
          (command (_)+ @control_structure_body)
        )
      )

      (if_statement
        (else_clause
          (command (_)+ @control_structure_body)
        )
      )
    ]],
  },
  {
    langs = { "groovy" },
    query = [[
      (if_statement body: (_) @control_structure_body)

      (if_statement else_body: (_) @control_structure_body)
    ]],
  },
  {
    langs = { "kotlin" },
    query = [[
      (if_expression consequence: (control_structure_body) @control_structure_body)

      (if_expression alternative: (control_structure_body) @control_structure_body)
    ]],
  },
  {
    langs = { "php" },
    query = [[
      (if_statement body: (_) @control_structure_body)

      (if_statement alternative:
        (else_if_clause body: (_) @control_structure_body)
      )

      (if_statement alternative:
        (else_clause body: (_) @control_structure_body)
      )
    ]],
  },
}

local function register_query_control_structure_body()
  for _, entry in ipairs(if_else_query_map) do
    local full_query = ";; extends\n" .. entry.query

    for _, lang in ipairs(entry.langs) do
      pcall(vim.treesitter.query.set, lang, "textobjects", full_query)
    end
  end
end

register_query_control_structure_body()



vim.api.nvim_create_autocmd({ "VimEnter", "FileType" }, {
  callback = function(event)
    local buf = event.buf
    local ft = vim.bo[buf].filetype

    if ft == "" or vim.bo[buf].buftype ~= "" then
      return
    end

    local lang = vim.treesitter.language.get_lang(ft)

    local success, has_parser = pcall(vim.treesitter.language.add, lang)
    if not has_parser and autoinstall then
        local success, installed = pcall(function (lang) nvim_ts.install(lang):wait(300000) end, lang)
        if not success or not installed then
            return
        end
    end

    vim.treesitter.start(buf, lang)
    setup_keybinds()

    vim.bo[buf].indentexpr = "v:lua.vim.treesitter.indentexpr()"

    local win = vim.api.nvim_get_current_win()
    vim.wo[win].foldmethod = "expr"
    vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[win].foldlevel = 99
  end,
})

