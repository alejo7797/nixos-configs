--# selene: allow(undefined_variable)

return {

  s(
    {
      trig = "module",
      dscr = "Simple NixOS / Home Manager module",
    },
    fmt(
      [[
        { config, lib, pkgs, ... }:

        let
          cfg = config.{1};
        in

        {
          options.{1} = {

            enable = lib.mkEnableOption "{2}";

          };

          config = lib.mkIf cfg.enable {

            {0}

          };
        }
      ]],
      {
        i(1, "<name>"),
        i(2, "<fullName>"),
      }
    )
  ),

}
