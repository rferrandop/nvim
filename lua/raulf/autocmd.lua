-- Format on autosave
--vim.api.nvim_create_autocmd("BufWritePre", {
--    pattern = "*",
--    callback = function()
--        vim.lsp.buf.format({ lazy = false })
--    end
--})

-- New Java file: insert package declaration + class skeleton
vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.java",
    callback = function()
        local filepath = vim.fn.expand("%:p")
        local classname = vim.fn.expand("%:t:r")

        -- Derive package from path: look for src/main/java or src/test/java roots,
        -- fall back to src/java, then plain src
        local package = nil
        local roots = { "src/main/java/", "src/test/java/", "src/java/", "src/" }
        for _, root in ipairs(roots) do
            local pattern = root:gsub("/", "[/\\]")
            local _, last = filepath:find(pattern)
            if last then
                local rel = filepath:sub(last + 1)
                -- strip trailing /ClassName.java
                rel = rel:match("^(.*)[/\\][^/\\]+%.java$")
                if rel then
                    package = rel:gsub("[/\\]", ".")
                end
                break
            end
        end

        local lines = {}

        if package and package ~= "" then
            table.insert(lines, "package " .. package .. ";")
            table.insert(lines, "")
        end

        table.insert(lines, "public class " .. classname .. " {")
        table.insert(lines, "")
        table.insert(lines, "}")

        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

        -- Place cursor inside the class body
        vim.api.nvim_win_set_cursor(0, { #lines - 1, 0 })
    end,
})
