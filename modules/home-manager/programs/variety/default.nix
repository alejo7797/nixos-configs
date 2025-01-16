{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.variety;
in

{
  options.myHome.variety.enable = lib.mkEnableOption "Variety";

  config = lib.mkIf cfg.enable {

    home.packages = [ pkgs.variety ];

    systemd.user.services.variety = config.myHome.lib.mkGraphicalService {
      Unit.Description = "Variety wallpaper changer";
      Service.ExecStart = "${pkgs.variety}/bin/variety";
    };

    programs.zsh.shellAliases =
      let
        variety = "${pkgs.variety}/bin/variety";
      in
      {
        bgnext = "${variety} --next";
        bgprev = "${variety} --previous";
        bgtrash = "${variety} --trash";
        bgfav = "${variety} --favorite";
      };

    # The script cannot be read-only, otherwise Variety won't run.
    home.activation.variety = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      install -Dm744 ${./set_wallpaper} -t ${config.xdg.configHome}/variety/scripts
    '';
  };
}
