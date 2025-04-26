--# selene: allow(undefined_variable)

return {

	s(
		{
			trig = "module",
			dscr = "Simple NixOS / Home Manager module",
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
