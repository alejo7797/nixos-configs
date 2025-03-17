{ config, lib, pkgs, ... }:

let
  cfg = config.my.variety;
in

{
  options.my.variety.enable = lib.mkEnableOption "Variety";

  config = lib.mkIf cfg.enable {

    # TODO: manage variety.conf, with scripts as derivations

    home.packages = [ pkgs.variety ];

    systemd.user.services.variety = config.myHome.lib.mkGraphicalService {
      Unit.Description = "Variety wallpaper changer";
      Service.ExecStart = "${pkgs.variety}/bin/variety";
    };

    programs.zsh.shellAliases = {
      bgnext = "variety --next";
      bgprev = "variety --previous";
      bgtrash = "variety --trash";
      bgfav = "variety --favorite";
    };

    # The script cannot be read-only, otherwise Variety won't run.
    home.activation.variety = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      install -Dm755 ${./set_wallpaper} -T ${config.xdg.configHome}/variety/scripts/set_wallpaper
    '';
  };
}
