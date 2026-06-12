local servers = { "lua_ls", "ruff", "basedpyright", "gopls", "yamlls", "terraformls", "rust_analyzer" }

return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = servers,
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
                local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
                local bufnr = event.buf

                local map = function(keys, action, desc)
                    vim.keymap.set("n", keys, action, {
                        buffer = bufnr,
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
                map("<leader>e", vim.diagnostic.open_float, "Line Diagnostic")
                map("<leader>q", vim.diagnostic.setloclist, "Diagnostics List")
                map("<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, "Format")

                map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
                map("]d", vim.diagnostic.goto_next, "Next Diagnostic")

                if client:supports_method("textDocument/completion", bufnr) and vim.lsp.completion then
                    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
                end

                if client:supports_method("textDocument/inlayHint", bufnr) and vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                    map("<leader>ih", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), {
                            bufnr = bufnr,
                        })
                    end, "Toggle Inlay Hints")
                end

                if client:supports_method("textDocument/codeLens", bufnr) and vim.lsp.codelens then
                    vim.lsp.codelens.enable(true, { bufnr = bufnr })
                    map("<leader>cl", vim.lsp.codelens.run, "Run Code Lens")
                end

                if client:supports_method("textDocument/documentHighlight", bufnr) and not vim.b[bufnr].lsp_document_highlight then
                    vim.b[bufnr].lsp_document_highlight = true
                    local highlight_group = vim.api.nvim_create_augroup("user-lsp-highlight-" .. bufnr, {
                        clear = true,
                    })

                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = bufnr,
                        group = highlight_group,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = bufnr,
                        group = highlight_group,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })

        require("mason-lspconfig").setup(opts)

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
