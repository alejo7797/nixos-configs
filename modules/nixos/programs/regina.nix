{ config, lib, pkgs, ... }:

let
  cfg = config.programs.my.regina;

  regina-env = pkgs.python3.withPackages (ps: with ps; [
    snappy tkinter (toPythonModule pkgs.regina-normal)
  ]);
in

{
  options.programs.my.regina.enable = lib.mkEnableOption "Regina";

  config = lib.mkIf cfg.enable {

    environment = {

      systemPackages = [ pkgs.regina-normal ];

      variables = { # Help Regina communicate directly with SnapPy.
        REGINA_PYLIBDIR = "${regina-env}/${regina-env.sitePackages}";
      };

    };
  };
}
