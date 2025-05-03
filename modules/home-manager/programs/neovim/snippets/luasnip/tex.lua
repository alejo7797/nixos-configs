--# selene: allow(undefined_variable)

local helpers = require("_helpers")
local get_visual = helpers.get_visual

-- Expand snippets only at the start of a line, like UltiSnips' flag `b`.
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local in_mathzone = function()
	-- This helper function requires the VimTeX plugin.
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local in_env = function(name)
  -- Generic environment detection thanks to VimTeX.
  local is_inside = vim.fn["vimtex#env#is_inside"](name)
  return (is_inside[1] > 0 and is_inside[2] > 0)
end

return {

	s(
		"emph",
		fmta("\\emph{<>}", {
			d(1, get_visual),
		})
	),

	s(
		"lr(",
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
      trig = "item",
      condition = line_begin,
      wordTrig = false,
    },
    fmta(
      [[
        \begin{itemize}
          \item <>
        \end{itemize}
      ]],
      {
        i(0),
      }
    )
  ),

  s(
    {
      trig = "enum",
      condition = line_begin,
      wordTrig = false,
    },
    fmta(
      [[
        \begin{enumerate}
          \item <>
        \end{enumerate}
      ]],
      {
        i(0),
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
				i(0),
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
				i(0),
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
				i(0),
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
				i(0),
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
				i(0),
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
			trig = "^^",
			condition = in_mathzone,
			wordTrig = false,
		},
		fmta("^{<>}", {
			i(1),
		})
	),

	s(
		{
			trig = "__",
			condition = in_mathzone,
			wordTrig = false,
		},
		fmta("_{<>}", {
			i(1),
		})
	),

	s(
		{
			trig = "//",
			condition = in_mathzone,
			wordTrig = false,
		},
		fmta("\\frac{<>}{<>}", {
			d(1, get_visual),
			i(2),
		})
	),

	s(
		{
			trig = "hat",
			condition = in_mathzone,
			wordTrig = true,
		},
		fmta("\\hat{<>}", {
			d(1, get_visual),
		})
	),

	s(
		{
			trig = "xx",
			condition = in_mathzone,
			wordTrig = false,
		},
    {
      t("\\times"),
    }
	),

  s(
    {
      trig = [[\\\]],
      condition = in_mathzone,
      wordTrig = false,
    },
    {
      t("\\setminus"),
    }
  ),

	s(
    {
      trig = "->",
      condition = in_mathzone,
      wordTrig = false,
    },
    {
      t("\\to"),
    }
  ),

  s(
    {
      trig = "cc",
      condition = in_mathzone,
      wordTrig = false,
    },
    {
      t("\\subset")
    }
  ),

  s(
    {
      trig = "c=",
      condition = in_mathzone,
      wordTrig = false,
    },
    {
      t("\\subseteq")
    }
  ),

  s(
    {
      trig = "arrow",
      condition = in_env("tikzcd"),
      wordTrig = true,
    },
    fmta("\\arrow[<>]", {
      i(1),
    })
  ),

}
