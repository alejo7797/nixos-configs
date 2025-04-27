--# selene: allow(undefined_variable)

local helpers = require("_helpers")
local get_visual = helpers.get_visual

-- Expand snippets only at the start of a line, like UltiSnips' flag `b`.
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local in_mathzone = function()
	-- This helper function requires the VimTeX plugin.
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

return {

	s(
		"lr",
		fmta("\\left(<>\\right)", {
			d(1, get_visual),
		})
	),

	s(
		"lr[",
		fmta("\\left[<>\\right]", {
			d(1, get_visual),
		})
	),

	s(
		"lr{",
		fmta("\\left\\{<>\\right\\}", {
			d(1, get_visual),
		})
	),

	s(
		"lr|",
		fmta("\\left\\|<>\\right\\|", {
			d(1, get_visual),
		})
	),

	s(
		"lra",
		fmta("\\left\\langle<>\\right\\rangle", {
			d(1, get_visual),
		})
	),

}, {

	s(
		"mk",
		fmta("\\(<>\\)", {
			i(1),
		})
	),

	s(
		"dm",
		fmta("\\[\n\t<>\n\\]", {
			i(0),
		})
	),

  s(
    {
      trig = "beg",
      condition = line_begin,
      wordTrig = false,
    },
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      {
        i(1, "env"),
        d(2, get_visual),
        rep(1),
      }
    )
  ),

  s(
    {
      trig = "thm",
      condition = line_begin,
      wordTrig = false,
    },
    fmta(
      [[
        \begin{thm}
            <>
        \end{thm}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),

  s(
    {
      trig = "prop",
      condition = line_begin,
      wordTrig = false,
    },
    fmta(
      [[
        \begin{prop}
            <>
        \end{prop}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),

  s(
    {
      trig = "defn",
      condition = line_begin,
      wordTrig = false,
    },
    fmta(
      [[
        \begin{defn}
            <>
        \end{defn}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),

  s(
    {
      trig = "exmp",
      condition = line_begin,
      wordTrig = false,
    },
    fmta(
      [[
        \begin{exmp}
            <>
        \end{exmp}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),

  s(
    {
      trig = "rem",
      condition = line_begin,
      wordTrig = false,
    },
    fmta(
      [[
        \begin{rem}
            <>
        \end{rem}
      ]],
      {
        d(1, get_visual),
      }
    )
  ),

  s(
    {
      trig = "ali",
      condition = line_begin,
      wordTrig = false,
    },
    fmta(
      [[
        \begin{align*}
            <>
        \end{align*}
      ]],
      {
        i(0),
      }
    )
  ),

  s(
    {
      trig = "eqn",
      condition = line_begin,
      wordTrig = false,
    },
    fmta(
      [[
        \begin{equation}
            <>
        \end{equation}
      ]],
      {
        i(0),
      }
    )
  ),

	s(
    {
      trig = "//",
      condition = in_mathzone,
      wordTrig = false,
    },
    fmta("\\frac{<>}{<>}",
      {
        d(1, get_visual),
        i(2),
      }
    )
  ),

	s(
    {
      trig = "->",
      condition = in_mathzone,
      wordTrig = false,
    },
    t("\\to")
  ),

}
