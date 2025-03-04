{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.retroarch;
in

{
  options.myNixOS.retroarch.enable = lib.mkEnableOption "RetroArch";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [

      (retroarch.override {

        cores = with libretro; [

          # For the list of cores and other information check these sites:
          # https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/emulators/libretro
          # https://emulation.gametechwiki.com/index.php/Main_Page

          mesen          # Famicom
          mgba           # Game Boy
          bsnes          # Super Famicom
          mupen64plus    # Nintendo 64
          dolphin        # GameCube + Wii
          melonds        # Nintendo DS
          citra          # Nintedo 3DS

          beetle-psx-hw  # PSX
          ppsspp         # PSP

        ];
      })
    ];
  };
}
