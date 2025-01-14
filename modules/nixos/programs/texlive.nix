{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.texlive;
in

{
  options.myNixOS.texlive.enable = lib.mkEnableOption "TeX Live";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [

      (texliveMedium.withPackages (
        ps: with ps; [
          collection-langcyrillic
          enumitem footmisc titling
        ]
      ))

    ];
  };
}
