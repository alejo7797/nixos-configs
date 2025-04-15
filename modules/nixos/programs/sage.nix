{ config, lib, pkgs, ... }:

let
  cfg = config.programs.my.sage;
in

{
  options.programs.my.sage.enable = lib.mkEnableOption "Sage";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [

      (sage.override {
        inherit pkgs; requireSageTests = false;
        extraPythonPackages = ps: [ ps.snappy ];
      })

    ];
  };
}
