{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.nginx;
in

{
  options.myNixOS.nginx.enable = lib.mkEnableOption "nginx";

  config = lib.mkIf cfg.enable {

    services.nginx = {
      enable = true;
    };

  };
}
