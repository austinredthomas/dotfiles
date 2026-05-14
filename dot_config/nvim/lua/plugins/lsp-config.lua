return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = { "lua_ls", "ruff", "basedpyright", "gopls", "yamlls" },
        automatic_enable = false,
    },
    config = function(_, opts)
        vim.diagnostic.config({
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            virtual_text = { source = "if_many" },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(event)
                local map = function(keys, action, desc)
                    vim.keymap.set("n", keys, action, {
                        buffer = event.buf,
                        desc = "LSP: " .. desc,
                    })
                end

                map("gd", vim.lsp.buf.definition, "Go to Definition")
                map("gD", vim.lsp.buf.declaration, "Go to Declaration")
                map("gi", vim.lsp.buf.implementation, "Go to Implementation")
                map("gr", vim.lsp.buf.references, "Find References")
                map("K", vim.lsp.buf.hover, "Hover Documentation")
                map("<leader>rn", vim.lsp.buf.rename, "Rename")
                map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
                map("<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, "Format")

                map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
                map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
            end,
        })

        require("mason-lspconfig").setup(opts)

        local servers = { "lua_ls", "ruff", "basedpyright", "gopls", "yamlls" }
        if vim.lsp.enable then
            vim.lsp.enable(servers)
        else
            local lspconfig = require("lspconfig")
            for _, server in ipairs(servers) do
                lspconfig[server].setup({})
            end
        end
    end,
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
