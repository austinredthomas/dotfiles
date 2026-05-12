return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>n", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Tree" },
    },
    opts = {
        view = {
            width = 35,
        },
        renderer = {
            group_empty = true,
        },
        filters = {
            dotfiles = false,
        },
    },
}
