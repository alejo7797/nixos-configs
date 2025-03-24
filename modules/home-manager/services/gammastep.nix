{ lib, ... }: {

  services.gammastep = {

    tray = true;

    provider = lib.mkDefault "geoclue2";

    settings.general = {
      fade = 1; gamma = 0.8;
      adjustment-method = "wayland";
    };

  };

}
