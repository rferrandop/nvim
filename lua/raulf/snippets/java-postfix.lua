-- Postfix snippets para Java usando LuaSnip
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local postfix = require("luasnip.extras.postfix").postfix

return {
    -- .for -> for-each loop
    postfix(".for", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("for (var item : "),
                t(match),
                t({ ") {", "\t" }),
                i(1),
                t({ "", "}" }),
            })
        end),
    }),

    -- .fori -> indexed for loop
    postfix(".fori", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("for (int i = 0; i < "),
                t(match),
                t({ ".length; i++) {", "\t" }),
                i(1),
                t({ "", "}" }),
            })
        end),
    }),

    -- .if -> if statement
    postfix(".if", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("if ("),
                t(match),
                t({ ") {", "\t" }),
                i(1),
                t({ "", "}" }),
            })
        end),
    }),

    -- .else -> if negated
    postfix(".else", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("if (!("),
                t(match),
                t({ ")) {", "\t" }),
                i(1),
                t({ "", "}" }),
            })
        end),
    }),

    -- .null -> null check
    postfix(".null", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("if ("),
                t(match),
                t({ " == null) {", "\t" }),
                i(1),
                t({ "", "}" }),
            })
        end),
    }),

    -- .nn -> not null check
    postfix(".nn", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("if ("),
                t(match),
                t({ " != null) {", "\t" }),
                i(1),
                t({ "", "}" }),
            })
        end),
    }),

    -- .var -> assign to variable
    postfix(".var", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("var "),
                i(1, "name"),
                t(" = "),
                t(match),
                t(";"),
            })
        end),
    }),

    -- .return -> return statement
    postfix(".return", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("return "),
                t(match),
                t(";"),
            })
        end),
    }),

    -- .sout -> System.out.println
    postfix(".sout", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("System.out.println("),
                t(match),
                t(");"),
            })
        end),
    }),

    -- .soutv -> System.out.println with variable name
    postfix(".soutv", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t('System.out.println("'),
                t(match),
                t(' = " + '),
                t(match),
                t(");"),
            })
        end),
    }),

    -- .throw -> throw exception
    postfix(".throw", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("throw "),
                t(match),
                t(";"),
            })
        end),
    }),

    -- .cast -> type cast
    postfix(".cast", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("("),
                i(1, "Type"),
                t(") "),
                t(match),
            })
        end),
    }),

    -- .field -> create field from local
    postfix(".field", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("private "),
                i(1, "Type"),
                t(" "),
                t(match),
                t(";"),
            })
        end),
    }),

    -- .opt -> Optional.ofNullable
    postfix(".opt", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t("Optional.ofNullable("),
                t(match),
                t(")"),
            })
        end),
    }),

    -- .stream -> stream()
    postfix(".stream", {
        d(1, function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            return sn(nil, {
                t(match),
                t(".stream()"),
            })
        end),
    }),
}
