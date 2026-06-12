local parsers = {
    "bash",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "hcl",
    "json",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "rust",
    "tmux",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
}

local filetypes = {
    "go",
    "gomod",
    "gosum",
    "gowork",
    "hcl",
    "help",
    "json",
    "lua",
    "markdown",
    "python",
    "query",
    "rust",
    "sh",
    "terraform",
    "tmux",
    "toml",
    "vim",
    "yaml",
}

return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = parsers,
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        })

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
            pattern = filetypes,
            callback = function()
                vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                vim.wo[0][0].foldmethod = "expr"
            end,
        })
    end,
}
