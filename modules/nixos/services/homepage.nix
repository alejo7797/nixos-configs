{
  lib,
  config,
  ...
}:

let
  cfg = config.myNixOS.homepage;
in

{
  options.myNixOS.homepage.enable = lib.mkEnableOption "Homepage Dashboard";

  config = lib.mkIf cfg.enable {



  };
}
