{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.fcitx5;
in

{

  options.myNixOS.fcitx5.enable = lib.mkEnableOption "Fcitx5";

  config = lib.mkIf cfg.enable {

    # Enable and configure Fcitx5.
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        plasma6Support = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-rime
        ];
      };
    };

    # And define the following environment variables.
    environment.variables = {
      SDL_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };
  };
}
