{ config, lib, pkgs, ... }:

let
  inherit (config.programs) direnv;
  cfg = config.programs.zsh.my.powerlevel10k;
in

{
  options = {

    programs.zsh.my.powerlevel10k = {

      enable = lib.mkEnableOption "Powerlevel10k prompt";

      preset = lib.mkOption {
        type = with lib.types; nullOr (enum [
          "p10k-classic" "p10k-lean-8colors" "p10k-lean"
          "p10k-pure" "p10k-rainbox" "p10k-robbyrussell"
        ]);
        description = "~/.p10k.zsh preset";
        default = "p10k-classic";
      };

      p10k-zsh = lib.mkOption {
        type = with lib.types; nullOr (either path lines);
        description = "~/.p10k.zsh file"; default = null;
      };

    };

  };

  config = lib.mkIf cfg.enable {

    programs.zsh = {

      my.powerlevel10k = lib.mkIf (cfg.preset != null) {

        p10k-zsh = lib.mkDefault (builtins.readFile (pkgs.zsh-powerlevel10k + "/share/zsh-powerlevel10k/config/${cfg.preset}.zsh"));

      };

      initExtraFirst =

        lib.optionalString (direnv.enable && direnv.enableZshIntegration) ''
          emulate zsh -c "$(direnv export zsh)"
        ''
        +
        ''
          if [[ -r "$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '';

      plugins =

        let
          config-package = pkgs.runCommand "p10k-config"
            {
              p10k_zsh = if builtins.isPath cfg.p10k-zsh || lib.isStorePath cfg.p10k-zsh then
                cfg.p10k-zsh
              else
                pkgs.writeText "p10k-zsh" cfg.p10k-zsh;
            }
            ''
              install -Dm644 "$p10k_zsh" "$out/p10k-config.plugin.zsh"
            '';
        in

        [
          {
            name = "powerlevel10k"; file = "powerlevel10k.zsh-theme";
            src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
          }
        ]

        ++ lib.optional (cfg.p10k-zsh != null)
        {
          name = "p10k-config"; src = config-package;
        }
      ;


    };

  };
}
