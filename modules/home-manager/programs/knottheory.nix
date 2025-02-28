{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.knotTheory;

  init = ''
    AppendTo[$Path, "${pkgs.knottheory}/share/WolframEngine/Applications"]

    QuantumGroupsDataDirectory[] := "$UserBaseDirectory/Applications/QuantumGroups/data"
  '';
in

{
  options.myHome.knotTheory.enable = lib.mkEnableOption "KnotTheory";

  config = lib.mkIf cfg.enable {

    home.file.".WolframEngine/Kernel/init.m".text = init;

    home.file.".Wolfram/Kernel/init.m".text = init;

  };
}
