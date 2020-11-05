local nvim_lsp = require("nvim_lsp")

local map = function(type, key, value)
    vim.api.nvim_buf_set_keymap(0, type, key, value, {noremap = true, silent = true})
end

vim.api.nvim_set_keymap('n', '<leader><Space>', ':set hlsearch!<cr>', { noremap = true, silent = true })
-- :nnoremap <silent> <leader><Space> :set hlsearch<cr>

local init = {}

local on_attach_lsp = function()
    print("LSP started")
    require "completion".on_attach(
        {
            enable_auto_popup = 1,
            auto_change_source = 1,
            matching_strategy_list = {"exact", "substring", "fuzzy"},
            trigger_keyword_length = 2,
            chain_complete_list = {
                json = {
                    {complete_items = {"path"}, triggered_only = {"/"}},
                },
                default = {
                    {complete_items = {"path"}, triggered_only = {"/"}},
                    {complete_items = {"lsp"}},
                    {mode = "line"},
                    {mode = "<c-n>"},
                    {mode = "<c-p>"}
                }
            }
        }
    )
    require "diagnostic".on_attach(
        {
            enable_virtual_text = 0,
            insert_delay = 1,
            virtual_text_prefix = "x"
        }
    )

    map("n", "gd", ":lua vim.lsp.buf.definition()<cr>")
    map("n", "gD", ":lua vim.lsp.buf.declaration()<cr>")
    map("n", "K", ":lua vim.lsp.buf.hover()<cr>")
    map("n", "gi", ":lua vim.lsp.buf.implementation()<cr>")
    map("n", "<c-k>", ":lua vim.lsp.buf.signature_help()<cr>")
    map("n", "1gD", ":lua vim.lsp.buf.type_definition()<cr>")
end

-- nvim_lsp.ccls.setup {
--     on_attach = on_attach,
--     init_options = {
--         highlight = {
--             lsRanges = true
--         }
--     }
-- }

nvim_lsp.sumneko_lua.setup { on_attach = on_attach_lsp }
nvim_lsp.clangd.setup {on_attach = on_attach_lsp}
nvim_lsp.pyls.setup {on_attach = on_attach_lsp}
nvim_lsp.texlab.setup {on_attach = on_attach_lsp}
nvim_lsp.jsonls.setup {on_attach = on_attach_lsp}
nvim_lsp.html.setup {on_attach = on_attach_lsp}
nvim_lsp.bashls.setup {on_attach = on_attach_lsp}
nvim_lsp.kotlin_language_server.setup {
    on_attach = on_attach_lsp,
    cmd = {"/home/anton/programs/kotlin-lsp-server/bin/kotlin-language-server"},
    root_dir = nvim_lsp.util.root_pattern("settings.gradle.kts")
}
nvim_lsp.tsserver.setup { on_attach = on_attach_lsp }
nvim_lsp.vimls.setup {on_attach = on_attach_lsp}

require "nvim-treesitter.configs".setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = {"c", "cpp", "python"} -- list of language that will be disabled
    }
}

require "telescope".setup {
    defaults = {
        theme = "dropdown",
        winblend = 20,
        sorting_strategy = "ascending",
        layout_strategy = "center",
        results_title = false,
        preview_title = "Preview",
        preview_cutoff = 1, -- Preview should always show (unless previewer = false)
        width = 0.7,
        results_height = 0.7,
        borderchars = {
            {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
            prompt = {"─", "│", " ", "│", "╭", "╮", "│", "│"},
            results = {"─", "│", "─", "│", "├", "┤", "╯", "╰"},
            preview = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"}
        },
    }
}
map("n", "<leader>r", ":lua require'telescope.builtin'.lsp_references{}<cr>")
map("n", "<leader>w", ":lua require'telescope.builtin'.lsp_workspace_symbols{}<cr>")

function init.attach_lsp()
    on_attach_lsp()
end

return init
