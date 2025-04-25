--# selene: allow(undefined_variable)

local helpers = require("_helpers")
local get_visual = helpers.get_visual

return {}, {

	s(
		{
			trig = "([^%a])mk",
      wordTrig = false,
      regTrig = true,
		},
		fmta(
      "<>\\(<>\\)",
      {
        f(function(_, snip)
          return snip.captures[1]
        end),
        d(1, get_visual),
      }
    )
	),

}

-- rule("\\[", "\\]", "tex"),
--
-- rule("\\left(", "\\right)", "tex"),
-- rule("\\left\\{", "\\right\\}", "tex"),
-- rule("\\left[", "\\right]", "tex"),
--
-- -- More LaTeX delimiters.
-- rule("\\langle", "\\rangle", "tex"),
-- rule("\\{", "\\}", "tex"),

--
-- snippet defn Add a definition
--         \begin{defn}
--             $0
--         \end{defn}
--
-- snippet defn Add an example
--         \begin{exmp}
--             $0
--         \end{exmp}
--
-- snippet prop Add a proposition
--         \begin{prop}
--             $0
--         \end{prop}
--
-- snippet thm Add a theorem
--         \begin{thm}
--             $0
--         \end{thm}
--
-- snippet rem Add a remark
--         \begin{rem}
--             $0
--         \end{rem}
--
-- snippet rar →
--         \rightarrow $0
--
