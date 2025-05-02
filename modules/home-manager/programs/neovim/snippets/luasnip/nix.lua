--# selene: allow(undefined_variable)

-- Expand snippets only at the start of a line, like UltiSnips' flag `b`.
local line_begin = require("luasnip.extras.expand_conditions").line_begin

return {

	s(
		{
			trig = "module",
			condition = line_begin,
			wordTrig = false,
		},
		fmta(
			[[
        { config, lib, pkgs, ... }:

        let
          cfg = config.<>;
        in

        {
          options.<> = {

            enable = lib.mkEnableOption "<>";

          };

          config = lib.mkIf cfg.enable {

            <>

          };
        }
      ]],
			{
				i(1, "name"),
				rep(1),
				d(2, function(args)
					return sn(nil, i(1, args[1]))
				end, { 1 }),
				i(0),
			}
		)
	),

}
