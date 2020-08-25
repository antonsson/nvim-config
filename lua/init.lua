local nvim_lsp = require("nvim_lsp")

local on_attach = function(_, bufnr)
    require "completion".on_attach()
    require "diagnostic".on_attach()
end

nvim_lsp.ccls.setup {
    on_attach = on_attach,
    init_options = {
        highlight = {
            lsRanges = true,
        }
    }
}

nvim_lsp.pyls.setup {on_attach = on_attach}
nvim_lsp.texlab.setup {on_attach = on_attach}
nvim_lsp.jsonls.setup {on_attach = on_attach}
nvim_lsp.html.setup {on_attach = on_attach}
nvim_lsp.bashls.setup {on_attach = on_attach}
-- nvim_lsp.kotlin_language_server.setup {on_attach = on_attach}
nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    settings = {cmd = {"typescript-language-server", "--stdio"}}
}
nvim_lsp.vimls.setup {on_attach = on_attach}
