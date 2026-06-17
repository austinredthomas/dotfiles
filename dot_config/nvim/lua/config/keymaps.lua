vim.keymap.set("i", "<C-j>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-n>"
    end

    return "<C-j>"
end, { expr = true, desc = "Completion: Next Item" })

vim.keymap.set("i", "<C-k>", function()
    if vim.fn.pumvisible() == 1 then
        return "<C-p>"
    end

    return "<C-k>"
end, { expr = true, desc = "Completion: Previous Item" })
