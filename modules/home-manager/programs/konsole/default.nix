{
  lib,
  config,
  ...
}:

let
  cfg = config.myHome.konsole;
  toINI = lib.generators.toINI {};
in

{
  options.myHome.konsole.enable = lib.mkEnableOption "Konsole configuration";

  config = lib.mkIf cfg.enable {

    xdg = {

      configFile."konsolerc".text = toINI {
        "Desktop Entry".DefaultProfile = "Default.profile";
      };

      dataFile."konsole/Default.profile".text = toINI {
        Appearance = {
          ColorScheme = "TomorrowNight";
          Font = "Hack Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
        };

        General.Name = "Default";
      };

      dataFile."konsole/TomorrowNight.colorscheme".source = ./TomorrowNight.colorscheme;

    };
  };
}
