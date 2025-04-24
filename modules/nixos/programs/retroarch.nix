{ config, lib, pkgs, ... }:

let
  cfg = config.programs.my.retroarch;
in

{
  options.programs.my.retroarch.enable = lib.mkEnableOption "RetroArch";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [(

      retroarch.override {
        cores = with libretro; [

          # https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/emulators/libretro
          # https://emulation.gametechwiki.com/index.php/Main_Page for the state of emulation

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
      }

    )];
  };
}
