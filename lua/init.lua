local nvim_lsp = require("nvim_lsp")

local map = function(type, key, value)
    vim.fn.nvim_buf_set_keymap(0, type, key, value, {noremap = true, silent = true})
end

local on_attach = function(_, bufnr)
    require "completion".on_attach()
    require "diagnostic".on_attach()
end

nvim_lsp.ccls.setup {
    on_attach = on_attach,
    init_options = {
        highlight = {
            lsRanges = true
        }
    }
}

nvim_lsp.pyls.setup {on_attach = on_attach}
nvim_lsp.texlab.setup {on_attach = on_attach}
nvim_lsp.jsonls.setup {on_attach = on_attach}
nvim_lsp.html.setup {on_attach = on_attach}
nvim_lsp.bashls.setup {on_attach = on_attach}
nvim_lsp.kotlin_language_server.setup {
    on_attach = on_attach,
    cmd = {"/home/anton/programs/kotlin-lsp-server/bin/kotlin-language-server"},
    root_dir = nvim_lsp.util.root_pattern("settings.gradle.kts")
}
nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    settings = {cmd = {"typescript-language-server", "--stdio"}}
}
nvim_lsp.vimls.setup {on_attach = on_attach}

require "nvim-treesitter.configs".setup {
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = {} -- list of language that will be disabled
    },
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
        }
    }
}
