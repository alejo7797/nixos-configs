{ pkgs, lib, config, ... }: {

  options.myNixOS.fcitx5.enable = lib.mkEnableOption "fcitx5";

  config = lib.mkIf config.myNixOS.fcitx5.enable {

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
